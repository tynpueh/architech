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

    blue_green_deployment_config {
        terminate_blue_instances_on_deployment_success {
            action = "TERMINATE"
            termination_wait_time_in_minutes = 5
        }

        deployment_ready_option {
            action_on_timeout = "CONTINUE_DEPLOYMENT"
        }
      
    }

    load_balancer_info {
        target_group_pair_info {
          prod_traffic_route {
            listener_arns = [var.alb_listener_arn]
          }

          target_group {
            name = var.target_group_blue_name
          }

          target_group {
            name = var.target_group_green_name
          }

          test_traffic_route {
            listener_arns = [var.alb_test_listener_arn]
          }
        }
    
    }

    auto_rollback_configuration {
        enabled = true
        events  = ["DEPLOYMENT_FAILURE"]
    }
  
}