module "vpc" {
    source = "../../modules/vpc"
    region = var.region
    environment = "stg"
}

module "alb" {
    source = "../../modules/alb"
    subnets = [module.vpc.public_subnet_id]
    vpc_id = module.vpc.vpc_id
    alb_name = "stg-alb"
    environment = "stg"
    certificate_arn = var.certificate_arn

}

module "ecs" {
    source = "../../modules/ecs"
    cluster_name = "stg-ecs-cluster"
    environment = "stg"
    subnets = [module.vpc.private_subnet_id]
    security_groups = [module.alb.alb_security_group_id]
    alb_target_group_arn = module.alb.alb_target_group_arn
    container_image = "${var.repository_name}:${var.version_image}"
  
}

module "ecr" {
    source = "../../modules/ecr"
    repository_name = "app"
    environment = "stg"
  
}