#!/bin/bash
# Crear buckets para cada ambiente
aws s3 rm s3://finaktiva-terraform-state-dev/terraform.tfstate
aws s3 rm s3://finaktiva-terraform-state-stg/terraform.tfstate
aws s3 rm s3://finaktiva-terraform-state-prod/terraform.tfstate

aws s3 mb s3://finaktiva-terraform-state-dev --region us-east-1
aws s3 mb s3://finaktiva-terraform-state-stg --region us-east-1
aws s3 mb s3://finaktiva-terraform-state-prod --region us-west-2

# Habilitar versionado
aws s3api put-bucket-versioning --bucket finaktiva-terraform-state-dev --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket finaktiva-terraform-state-stg --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket finaktiva-terraform-state-prod --versioning-configuration Status=Enabled





aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-2

