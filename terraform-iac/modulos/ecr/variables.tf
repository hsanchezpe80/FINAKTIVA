variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "app_names" {
  description = "Names of the applications to deploy"
  type        = list(string)
}