resource "aws_ecr_repository" "app" {
    name = "${var.repository_name}-${var.environment}"

    tags = {
        Name = "${var.repository_name}-${var.environment}"
    }
  
}