module "networking" {
  source = "./modulos/networking"
  
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  isolated_subnets_cidr = var.isolated_subnets_cidr
  availability_zones    = var.availability_zones
}

module "ecr" {
  source = "./modulos/ecr"
  
  environment = var.environment
  app_names   = var.app_names
}

module "security" {
  source = "./modulos/security"
  
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  allowed_ips           = var.allowed_ips
  certificate_domain    = var.certificate_domain
}

module "lb" {
  source = "./modulos/alb"
  
  environment         = var.environment
  vpc_id              = module.networking.vpc_id
  public_subnets      = module.networking.public_subnets
  alb_security_group  = module.security.alb_security_group_id
  acm_certificate_arn = module.security.certificate_arn
}

module "ecs" {
  source = "./modulos/ecs"
  
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  private_subnets           = module.networking.private_subnets
  app_names                 = var.app_names
  ecr_repositories          = module.ecr.repository_urls
  ecs_task_security_group   = module.security.ecs_task_security_group_id
  alb_security_group        = module.security.alb_security_group_id
  target_groups             = module.lb.target_groups
  deployment_strategy       = var.deployment_strategy
  min_capacity              = var.min_capacity
  max_capacity              = var.max_capacity
  cpu_threshold             = var.cpu_threshold
}