terraform {
  backend "s3" {
    # Los siguientes parámetros se configurarán dinámicamente durante la inicialización
    # usando el comando: terraform init -backend-config="key=value"
    #
    bucket         = "finaktiva-terraform-state-dev"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
    #
    # Ejemplo de inicialización:
    # terraform init \
    #   -backend-config="bucket=finaktiva-terraform-state-dev" \
    #   -backend-config="key=ecs-fargate/terraform.tfstate" \
    #   -backend-config="region=us-east-2" \
    #   -backend-config="dynamodb_table=terraform-state-lock"
  }
}