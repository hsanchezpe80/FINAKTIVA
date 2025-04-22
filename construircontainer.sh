#!/bin/bash
# Construir y subir los containers
aws ecr delete-repository --repository-name dev-api-service --force
aws ecr delete-repository --repository-name dev-worker-service --force


aws ecr create-repository --repository-name dev-api-service --region us-east-1
aws ecr create-repository --repository-name dev-worker-service --region us-east-1

set -e

# Obtener el ID de la cuenta AWS
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"

# Verificar que tenemos el ID de cuenta
if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo "Error: No se pudo obtener el ID de la cuenta AWS"
    echo "Verifica que AWS CLI esté configurado correctamente"
    exit 1
fi

echo "AWS Account ID: $AWS_ACCOUNT_ID"
echo "Region: $REGION"

# Autenticarse en ECR
echo "Autenticando en ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Construir y subir app1
echo "Construyendo el Dockerfile de la app1..."
cd apps/app1
docker build -t dev-api-service .
docker tag dev-api-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-api-service:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-api-service:latest
cd ../..

# Construir y subir app2
echo "Construyendo el Dockerfile de la app2..."
cd apps/app2
docker build -t dev-worker-service .
docker tag dev-worker-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-worker-service:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-worker-service:latest
cd ../..

echo "Imágenes construidas y subidas exitosamente a ECR"