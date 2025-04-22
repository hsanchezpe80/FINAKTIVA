output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = aws_ecr_repository.app_repo[*].repository_url
}

output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value       = aws_ecr_repository.app_repo[*].arn
}

output "repository_names" {
  description = "Names of the ECR repositories"
  value       = aws_ecr_repository.app_repo[*].name
}