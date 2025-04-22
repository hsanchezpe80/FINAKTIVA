variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Valid values for environment are: dev, stg, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "isolated_subnets_cidr" {
  description = "CIDR blocks for isolated subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to use for subnets"
  type        = list(string)
}

variable "app_names" {
  description = "Names of the applications to deploy"
  type        = list(string)
  default     = ["app1", "app2"]
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for ALB access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}



variable "deployment_strategy" {
  description = "Deployment strategy (BLUE_GREEN or ROLLING)"
  type        = string
  default     = "ROLLING"
  validation {
    condition     = contains(["BLUE_GREEN", "ROLLING"], var.deployment_strategy)
    error_message = "Valid values for deployment_strategy are: BLUE_GREEN, ROLLING."
  }
}

variable "min_capacity" {
  description = "Minimum number of tasks per service"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of tasks per service for auto-scaling"
  type        = number
  default     = 10
}

variable "cpu_threshold" {
  description = "CPU threshold percentage for auto-scaling"
  type        = number
  default     = 75
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}
