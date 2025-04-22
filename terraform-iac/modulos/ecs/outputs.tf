output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_names" {
  description = "Names of the ECS services"
  value       = aws_ecs_service.app[*].name
}

output "task_definition_arns" {
  description = "ARNs of the task definitions"
  value       = aws_ecs_task_definition.app[*].arn
}

output "autoscaling_target_ids" {
  description = "IDs of the autoscaling targets"
  value       = aws_appautoscaling_target.ecs_target[*].id
}