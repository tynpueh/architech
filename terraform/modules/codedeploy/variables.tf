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

variable "alb_listener_arn" {
    description = "The ARN of the ALB listener for production traffic"
    type        = string  

}

variable "target_group_blue_name" {
    description = "The name of the blue target group"
    type        = string  
  
}

variable "target_group_green_name" {
    description = "The name of the green target group"
    type        = string  
  
}

variable "alb_test_listener_arn" {
    description = "The ARN of the ALB listener for test traffic"
    type        = string
  
}
