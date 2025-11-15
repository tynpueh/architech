init-stg:
	terraform -chdir=./terraform/environments/stg init

plan-stg:
	terraform -chdir=./terraform/environments/stg validate
	terraform -chdir=./terraform/environments/stg plan -out=tfplan

apply-stg:
	terraform -chdir=./terraform/environments/stg validate
	terraform -chdir=./terraform/environments/stg apply -auto-approve

destroy-stg:
	terraform -chdir=./terraform/environments/stg destroy -auto-approve