init-stg:
	terraform -chdir=./terraform/environments/stg init

apply-stg:
	terraform --chdir=./terraform/environments/stg validate
	terraform -chdir=./terraform/environments/stg apply -auto-approve