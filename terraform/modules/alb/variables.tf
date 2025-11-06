variable "alb_name" {
    description = "The name of the Application Load Balancer"
    type        = string
}
variable "subnet_ids" {
    description = "A list of subnet IDs to attach to the ALB"
    type        = list(string)
}
variable "tags" {
    description = "A map of tags to assign to the ALB"
    type        = map(string)
    default     = {}
}

variable "vpc_id" {
    description = "The VPC ID where the ALB will be deployed"
    type        = string
  
}

variable "certificate_arn"  {
    description = "The ARN of the SSL certificate for HTTPS listener"
    type        = string
  
}