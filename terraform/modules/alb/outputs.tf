output "alb_security_group_id" {
    description = "The security group ID of the ALB"
    value       = aws_security_group.alb.id
  
}

output "alb_target_group_blue_arn" {
    description = "The ARN of the blue ALB target group for the app"
    value       = aws_lb_target_group.blue.arn
}

output "alb_target_group_green_arn" {
    description = "The ARN of the green ALB target group for the app"
    value       = aws_lb_target_group.green.arn
}

output "alb_dns_name" {
    description = "The DNS name of the ALB"
    value       = aws_lb.app.dns_name
}