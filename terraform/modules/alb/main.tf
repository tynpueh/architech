resource "aws_lb" "app" {
    name               = var.alb_name
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = var.subnet_ids
    enable_deletion_protection = false
    tags = var.tags
    }

resource "aws_security_group" "alb" {
    name        = "${var.alb_name}-sg"
    description = "Security group for ALB"
    vpc_id      = var.vpc_id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = var.tags
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.app.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Hello from ALB"
            status_code  = "200"
        }
    }
  
}

resource "aws_lb_listener" "https_listener" {
    load_balancer_arn = aws_lb.app.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy       = "ELBSecurityPolicy-2016-08"
    certificate_arn  = var.certificate_arn
    default_action {
        type             = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Hello from ALB"
            status_code  = "200"
        }
    }
}
