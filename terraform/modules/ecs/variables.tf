variable "cluster_name" {
    description = "The name of the ECS cluster"
    type        = string   
  
}

variable "environment" {
    description = "The environment for the ECS cluster"
    type        = string

}
variable "subnets" {
    description = "A list of subnet IDs for the ECS service"
    type        = list(string)
  
}
variable "security_groups" {
    description = "A list of security group IDs for the ECS service"
    type        = list(string)

}

variable "alb_target_group_arn" {
    description = "(Optional) ARN of an ALB target group to attach the ECS service to"
    type        = string
    default     = ""
}

variable "container_name" {
    description = "Name of the container in the task definition to register with the target group"
    type        = string
    default     = "app"
}

variable "container_port" {
    description = "Port on the container to register with the target group"
    type        = number
    default     = 80
}

# variable "ecr_repo_url" {
#   description = "ECR repository URL (without tag)"
# }