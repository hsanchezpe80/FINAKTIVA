provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Finaktiva-DevOps-Prueba"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}