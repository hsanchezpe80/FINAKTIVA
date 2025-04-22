variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_security_group" {
  description = "Security group ID for ALB"
  type        = string
}

variable "app_names" {
  description = "Nombres de las aplicaciones"
  type        = list(string)
}