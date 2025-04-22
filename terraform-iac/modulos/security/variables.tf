variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for ALB access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}