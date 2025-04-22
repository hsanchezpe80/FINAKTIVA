# Application Load Balancer
resource "aws_alb" "main" {
  name                       = "${var.environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group]
  subnets                    = var.public_subnets
  enable_deletion_protection = var.environment == "prod" ? true : false
  drop_invalid_header_fields = true

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

# Target groups para cada aplicación
resource "aws_alb_target_group" "app" {
  count       = length(var.app_names)
  name        = "${var.environment}-${var.app_names[count.index]}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}-tg"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# HTTP Listener (puerto 80)
resource "aws_alb_listener" "app" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app[0].arn  # Usar el primer target group por defecto
  }
}

# Reglas del listener para cada aplicación
resource "aws_alb_listener_rule" "app" {
  count        = length(var.app_names)
  listener_arn = aws_alb_listener.app.arn  # Cambiar a .app en lugar de .https
  priority     = 100 + count.index

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/${var.app_names[count.index]}*"]
    }
  }
}