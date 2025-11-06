provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = var.region
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = var.local_endpoint
    apigatewayv2   = var.local_endpoint
    cloudformation = var.local_endpoint
    cloudwatch     = var.local_endpoint
    dynamodb       = var.local_endpoint
    ec2            = var.local_endpoint
    es             = var.local_endpoint
    elasticache    = var.local_endpoint
    firehose       = var.local_endpoint
    iam            = var.local_endpoint
    kinesis        = var.local_endpoint
    lambda         = var.local_endpoint
    rds            = var.local_endpoint
    redshift       = var.local_endpoint
    route53        = var.local_endpoint
    s3             = var.s3_endpoint
    secretsmanager = var.local_endpoint
    ses            = var.local_endpoint
    sns            = var.local_endpoint
    sqs            = var.local_endpoint
    ssm            = var.local_endpoint
    stepfunctions  = var.local_endpoint
    sts            = var.local_endpoint
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "=6.18.0"
    }
  }
}