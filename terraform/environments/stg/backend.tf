terraform {
  backend "s3" {
    bucket         = "bucket"
    key            = "${terraform.workspace}/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = "terraform-locks"
    endpoint       = var.s3_endpoint
  }
}