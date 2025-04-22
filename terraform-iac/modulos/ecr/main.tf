# Usar data sources para referenciar repositorios ECR existentes
data "aws_ecr_repository" "app_repo" {
  count = length(var.app_names)
  name  = "${var.environment}-${var.app_names[count.index]}"
}