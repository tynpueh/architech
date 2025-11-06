resource "aws_ecs_cluster" "this" {
    name = var.cluster_name
    tags = {
        Name = "${var.cluster_name}-${var.environment}"
    }

}

resource "aws_ecs_task_definition" "app" {
    family                   = "${var.cluster_name}-app"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"

    container_definitions = jsonencode([
        {
            name      = "app"
            image     = "nginx:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                    protocol      = "tcp"
                }
            ]
        }
    ])
  
}

resource "aws_ecs_service" "app" {
    name            = "${var.cluster_name}-app-service"
    cluster         = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        subnets         = var.subnets
        security_groups = var.security_groups
        assign_public_ip = true
    }

    tags = {
        Name = "${var.cluster_name}-app-service-${var.environment}"
    }
  
}