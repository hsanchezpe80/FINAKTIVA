output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID de la VPC"
}

output "public_subnets" {
  value       = module.networking.public_subnets
  description = "IDs de las subredes públicas"
}

output "private_subnets" {
  value       = module.networking.private_subnets
  description = "IDs de las subredes privadas"
}

output "isolated_subnets" {
  value       = module.networking.isolated_subnets
  description = "IDs de las subredes aisladas"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Nombre DNS del balanceador de carga"
}

output "alb_zone_id" {
  value       = module.alb.alb_zone_id
  description = "Zone ID del balanceador de carga"
}

output "ecr_repository_urls" {
  value       = module.ecr.repository_urls
  description = "URLs de los repositorios ECR"
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
  description = "Nombre del cluster ECS"
}

output "ecs_service_names" {
  value       = module.ecs.service_names
  description = "Nombres de los servicios ECS"
}

output "task_definition_arns" {
  value       = module.ecs.task_definition_arns
  description = "ARNs de las definiciones de tareas"
}