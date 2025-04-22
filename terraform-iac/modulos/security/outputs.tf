output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "ecs_task_security_group_id" {
  description = "Security group ID for the ECS tasks"
  value       = aws_security_group.ecs_tasks.id
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.main.arn
}

output "certificate_domain" {
  description = "Domain of the ACM certificate"
  value       = aws_acm_certificate.main.domain_name
}