variable "name" {
    description = "The name of the CodeDeploy application"
    type        = string  

}

variable "environment" {
    description = "The environment for the CodeDeploy application"
    type        = string  

}

variable "service_role_arn" {
    description = "The ARN of the IAM role that allows CodeDeploy to access AWS services"
    type        = string  

}

variable "ecs_cluster_name" {
    description = "The name of the ECS cluster"
    type        = string  
  
}

variable "ecs_service_name" {
    description = "The name of the ECS service"
    type        = string
  
}
