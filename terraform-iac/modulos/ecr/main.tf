# Repositorios de ECR para las aplicaciones
resource "aws_ecr_repository" "app_repo" {
  count                = length(var.app_names)
  name                 = "${var.environment}-${var.app_names[count.index]}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}-ecr"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# Política de ciclo de vida para mantener solo las 10 imágenes más recientes
resource "aws_ecr_lifecycle_policy" "app_lifecycle_policy" {
  count      = length(var.app_names)
  repository = aws_ecr_repository.app_repo[count.index].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}