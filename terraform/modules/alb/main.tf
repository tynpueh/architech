resource "aws_lb" "app" {
    name               = var.alb_name
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = var.subnets
    enable_deletion_protection = false
    tags = {
        Name = "${var.alb_name}-${var.environment}"
    }

}

resource "aws_lb_target_group" "app_tg" {
    name        = "${var.alb_name}-tg"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id

    health_check {
        interval            = 30
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-399"
        timeout             = 5
        protocol            = "HTTP"
    }

    tags = merge(var.tags, { Name = "${var.alb_name}-tg-${var.environment}" })
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
    ingress {
        from_port   = 443
        to_port     = 443
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
        type             = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
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
        type = "forward"
        forward {
            target_group {
                arn = aws_lb_target_group.app_tg.arn
            }
        }
    }
}
