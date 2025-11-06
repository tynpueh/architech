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

# variable "ecr_repo_url" {
#   description = "ECR repository URL (without tag)"
# }