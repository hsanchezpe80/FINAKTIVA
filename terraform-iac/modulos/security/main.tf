# Security Group para el ALB
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  # Permitir acceso HTTPS desde IPs específicas
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
    description = "HTTPS access from allowed IPs"
  }

  # Permitir todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

# Security Group para las tareas de ECS
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # No permitir acceso directo desde internet
  # Solo permitir tráfico desde el ALB
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
    description     = "Access from ALB only"
  }

  # Permitir todo el tráfico de salida para que las tareas puedan acceder a servicios externos
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.environment}-ecs-tasks-sg"
  }
}

# Certificado SSL/TLS para HTTPS
resource "aws_acm_certificate" "main" {
  domain_name       = var.certificate_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.environment}-certificate"
    Environment = var.environment
  }
}

# Validación del certificado
# Este recurso simula la validación completada para entornos de prueba
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
}