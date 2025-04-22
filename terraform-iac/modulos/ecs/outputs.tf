output "cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "ID del cluster ECS"
}

output "cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "Nombre del cluster ECS"
}

output "task_execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN del rol de ejecución de tareas"
}

output "task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "ARN del rol de tareas"
}

output "service_names" {
  value       = aws_ecs_service.app[*].name
  description = "Nombres de los servicios ECS"
}

output "task_definition_arns" {
  value       = aws_ecs_task_definition.app[*].arn
  description = "ARNs de las definiciones de tareas"
}