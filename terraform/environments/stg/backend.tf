terraform {
  backend "s3" {
    bucket         = "bucket"
    key            = "stg/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
    endpoint       = "http://s3.localhost.localstack.cloud:4566"
  }
}