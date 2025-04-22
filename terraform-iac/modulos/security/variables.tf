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

variable "certificate_domain" {
  description = "Domain name for ACM certificate"
  type        = string
}