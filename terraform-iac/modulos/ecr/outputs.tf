output "repository_urls" {
  description = "URLs de los repositorios ECR"
  value       = data.aws_ecr_repository.app_repo[*].repository_url
}