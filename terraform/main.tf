# terraform/main.tf
module "prod" {
  source = "./environments/prod"
}

module "stg" {
  source = "./environments/stg"
}