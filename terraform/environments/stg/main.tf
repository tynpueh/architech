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
    certificate_arn = var.certificate_arn

}

module "ecs" {
    source = "../../modules/ecs"
    cluster_name = "stg-ecs-cluster"
    tags = "ecs-stg"
    subnets = [module.vpc.private_subnet_id]
    security_groups = [module.alb.alb_security_group_id]
  
}