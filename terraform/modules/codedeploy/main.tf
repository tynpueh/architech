resource "aws_codedeploy_app" "this" {
    name = "${var.name}-${var.environment}"
    compute_platform = "ECS"

}

resource "aws_codedeploy_deployment_group" "this" {
    app_name              = aws_codedeploy_app.this.name
    deployment_group_name = "${var.name}-dg-${var.environment}"
    service_role_arn      = var.service_role_arn

    deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

    ecs_service {
        cluster_name = var.ecs_cluster_name
        service_name = var.ecs_service_name
    }

    auto_rollback_configuration {
        enabled = true
        events  = ["DEPLOYMENT_FAILURE"]
    }
  
}