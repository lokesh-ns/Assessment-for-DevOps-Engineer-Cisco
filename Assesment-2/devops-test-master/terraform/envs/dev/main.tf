module "vpc" {
  source               = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/vpc"
  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecr" {
  source      = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/ecr"
  project     = var.project
  environment = var.environment
}

module "alb" {
  source             = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/alb"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
}

module "ecs" {
  source               = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/ecs"
  project              = var.project
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_id               = module.vpc.vpc_id
  private_subnet_1_id  = module.vpc.private_subnet_1_id
  private_subnet_2_id  = module.vpc.private_subnet_2_id
  alb_sg_id            = module.alb.alb_sg_id
  alb_target_group_arn = module.alb.target_group_arn
  ecr_repository_url   = module.ecr.repository_url
  api_image_tag        = var.api_image_tag
  redis_endpoint       = module.redis.redis_endpoint
  redis_port           = module.redis.redis_port
  api_desired_count    = var.api_desired_count
  api_cpu              = var.api_cpu
  api_memory           = var.api_memory
}

module "redis" {
  source              = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/redis"
  project             = var.project
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  ecs_sg_id           = module.ecs.ecs_sg_id
}

module "cloudfront" {
  source      = "/Users/lokeshns/Downloads/devops-test-master/terraform/modules/cloudfront"
  project     = var.project
  environment = var.environment
  alb_dns_name = module.alb.alb_dns_name
}