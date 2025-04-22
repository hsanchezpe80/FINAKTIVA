variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}

variable "aws_region" {
  description = "Región de AWS"
  type        = string
}

variable "app_names" {
  description = "Nombres de las aplicaciones"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "Subnets privadas para ECS"
  type        = list(string)
}

variable "ecr_repositories" {
  description = "URLs de los repositorios ECR"
  type        = list(string)
}

variable "target_groups" {
  description = "ARNs de los target groups"
  type        = list(string)
}

variable "ecs_tasks_security_group" {
  description = "Security group para las tareas de ECS"
  type        = string
}

variable "min_capacity" {
  description = "Número mínimo de tareas"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Número máximo de tareas"
  type        = number
  default     = 10
}

variable "cpu_threshold" {
  description = "Umbral de CPU para auto-scaling"
  type        = number
  default     = 75
}

variable "task_cpu" {
  description = "Unidades de CPU para la tarea"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memoria en MB para la tarea"
  type        = number
  default     = 512
}