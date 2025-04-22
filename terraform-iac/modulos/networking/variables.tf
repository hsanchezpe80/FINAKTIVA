variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
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