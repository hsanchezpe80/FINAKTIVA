output "vpc_id" {
  description = "ID de la VPC"
  value       = module.networking.vpc_id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "IDs de las subnets privadas"
  value       = module.networking.private_subnets
}

output "alb_dns_name" {
  description = "DNS del Load Balancer"
  value       = module.lb.alb_dns_name
}

output "ecr_repository_urls" {
  description = "URLs de los repositorios ECR"
  value       = module.ecr.repository_urls
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = module.ecs.cluster_name
}

output "ecs_service_names" {
  description = "Nombres de los servicios ECS"
  value       = module.ecs.service_names
}

output "certificate_arn" {
  description = "ARN del certificado ACM"
  value       = module.security.certificate_arn
}