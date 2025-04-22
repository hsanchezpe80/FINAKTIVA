variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}

variable "app_names" {
  description = "Nombres de las aplicaciones"
  type        = list(string)
}