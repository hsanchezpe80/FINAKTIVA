output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_alb.main.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_alb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_alb.main.zone_id
}

output "target_groups" {
  description = "ARNs of the target groups"
  value       = aws_alb_target_group.app[*].arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_alb_listener.https.arn
}