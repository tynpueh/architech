variable "s3_endpoint" {
  description = "S3 endpoint URL"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "local_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for HTTPS listener"
  type        = string
  
}

variable "repository_name" {
  description = "Container image to deploy to ECS"
  type        = string  
  
}

variable "version_image" {
  description = "Version tag for the container image"
  type        = string  
}