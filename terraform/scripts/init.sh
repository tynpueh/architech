#!/usr/bin/env bash
set -euo pipefail

BUCKET="${1:-${S3_BUCKET:-bucket}}"
REGION="${2:-${AWS_REGION:-ap-southeast-1}}"
ENDPOINT="${3:-${S3_ENDPOINT_URL:-http://localhost:4566}}"
DDB_TABLE="${4:-${DYNAMODB_TABLE:-terraform-locks}}"
AWS_CLI="${AWS_CLI:-aws}"
RETRIES="${RETRIES:-10}"
SLEEP="${SLEEP:-1}"

log() { printf '%s\n' "$*"; }
err() { log "ERROR: $*" >&2; }

run_aws() {
    if [ -n "${ENDPOINT:-}" ]; then
        "$AWS_CLI" --endpoint-url "$ENDPOINT" "$@"
    else
        "$AWS_CLI" "$@"
    fi
}

if ! command -v "$AWS_CLI" >/dev/null 2>&1; then
    err "aws CLI not found in PATH"
    exit 1
fi

ensure_s3_bucket() {
    local create_args
    if [ "$REGION" = "us-east-1" ]; then
        create_args=(--bucket "$BUCKET")
    else
        create_args=(--bucket "$BUCKET" --create-bucket-configuration "LocationConstraint=$REGION")
    fi

    if run_aws s3api head-bucket --bucket "$BUCKET" >/dev/null 2>&1; then
        log "Bucket '$BUCKET' already exists."
    else
        if run_aws s3api create-bucket "${create_args[@]}" --region "$REGION" >/dev/null 2>&1; then
            log "Bucket '$BUCKET' created."
        else
            err "Failed to create bucket '$BUCKET'."
            return 2
        fi
    fi

    for i in $(seq 1 "$RETRIES"); do
        if run_aws s3api head-bucket --bucket "$BUCKET" >/dev/null 2>&1; then
            log "Bucket '$BUCKET' is reachable."

            version_status=$(run_aws s3api get-bucket-versioning --bucket "$BUCKET" --query 'Status' --output text 2>/dev/null || true)
            if [ "$version_status" != "Enabled" ]; then
                if run_aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled --region "$REGION" >/dev/null 2>&1; then
                    log "Versioning enabled on bucket '$BUCKET'."
                else
                    err "Failed to enable versioning on bucket '$BUCKET'."
                    return 6
                fi
            else
                log "Versioning already enabled on bucket '$BUCKET'."
            fi

            return 0
        fi
        log "Waiting for bucket... ($i/$RETRIES)"
        sleep "$SLEEP"
    done

    err "Bucket '$BUCKET' did not become reachable in time."
    return 3
}

ensure_dynamodb_table() {
    if run_aws dynamodb describe-table --table-name "$DDB_TABLE" --region "$REGION" >/dev/null 2>&1; then
        log "DynamoDB table '$DDB_TABLE' already exists."
    else
        if run_aws dynamodb create-table \
            --table-name "$DDB_TABLE" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region "$REGION" >/dev/null 2>&1; then
            log "Creation requested for DynamoDB table '$DDB_TABLE'."
        else
            err "Failed to create DynamoDB table '$DDB_TABLE'."
            return 4
        fi
    fi

    for i in $(seq 1 "$RETRIES"); do
        status=$(run_aws dynamodb describe-table --table-name "$DDB_TABLE" --region "$REGION" --query 'Table.TableStatus' --output text 2>/dev/null || true)
        if [ "$status" = "ACTIVE" ]; then
            log "DynamoDB table '$DDB_TABLE' is ACTIVE."
            return 0
        fi
        log "Waiting for DynamoDB table to become ACTIVE... ($i/$RETRIES) (status=${status:-NONE})"
        sleep "$SLEEP"
    done

    err "DynamoDB table '$DDB_TABLE' did not become ACTIVE in time."
    return 5
}

main() {
    log "Creating S3 bucket: $BUCKET (region: $REGION) via endpoint: $ENDPOINT"
    ensure_s3_bucket || return $?

    log "Ensuring DynamoDB table for Terraform locking: $DDB_TABLE (region: $REGION) via endpoint: $ENDPOINT"
    ensure_dynamodb_table || return $?

    log "Infrastructure init completed successfully."
    return 0
}

main "$@"