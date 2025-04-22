# Application Load Balancer
resource "aws_alb" "main" {  # Cambiar a aws_alb en lugar de aws_lb
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
resource "aws_alb_target_group" "app" {  # Cambiar a aws_alb_target_group
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

# HTTPS Listener (puerto 443)
resource "aws_alb_listener" "https" {  # Cambiar a aws_alb_listener
  load_balancer_arn = aws_alb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Reglas del listener para cada aplicación
resource "aws_alb_listener_rule" "app" {  # Cambiar a aws_alb_listener_rule
  count        = length(var.app_names)
  listener_arn = aws_alb_listener.https.arn
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

# Redirección HTTP a HTTPS
resource "aws_alb_listener" "http_redirect" {  # Cambiar a aws_alb_listener
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
