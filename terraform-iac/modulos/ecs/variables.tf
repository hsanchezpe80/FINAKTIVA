variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "app_names" {
  description = "Names of the applications to deploy"
  type        = list(string)
}

variable "ecr_repositories" {
  description = "URLs of the ECR repositories"
  type        = list(string)
}

variable "ecs_task_security_group" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "alb_security_group" {
  description = "Security group ID for ALB"
  type        = string
}

variable "target_groups" {
  description = "ARNs of target groups for the ALB"
  type        = list(string)
}

variable "deployment_strategy" {
  description = "Deployment strategy (BLUE_GREEN or ROLLING)"
  type        = string
  default     = "ROLLING"
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