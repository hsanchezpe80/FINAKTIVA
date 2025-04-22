# Cluster de ECS
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.environment}-ecs-cluster"
  }
}

# Rol de ejecución para las tareas de Fargate
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Adjuntar política de ejecución de tareas
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Rol para las tareas de Fargate
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# CloudWatch Logs grupo para cada aplicación
resource "aws_cloudwatch_log_group" "app_logs" {
  count = length(var.app_names)
  name  = "/ecs/${var.environment}/${var.app_names[count.index]}"

  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}-logs"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# Definición de tareas para cada aplicación
resource "aws_ecs_task_definition" "app" {
  count                    = length(var.app_names)
  family                   = "${var.environment}-${var.app_names[count.index]}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.app_names[count.index]
      image     = "${var.ecr_repositories[count.index]}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app_logs[count.index].name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}-task"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# Servicios de ECS para cada aplicación
resource "aws_ecs_service" "app" {
  count                             = length(var.app_names)
  name                              = "${var.environment}-${var.app_names[count.index]}-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.app[count.index].arn
  desired_count                     = var.min_capacity
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_task_security_group]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_groups[count.index]
    container_name   = var.app_names[count.index]
    container_port   = 8080
  }

  # Configuración de despliegue basada en la estrategia
  deployment_controller {
    type = var.deployment_strategy == "BLUE_GREEN" ? "CODE_DEPLOY" : "ECS"
  }

  # Configuración de deployment estática
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [aws_ecs_task_definition.app]

  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}-service"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# Configuración de Auto-scaling para cada servicio de ECS
resource "aws_appautoscaling_target" "ecs_target" {
  count              = length(var.app_names)
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app[count.index].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Política de auto-scaling basada en CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count              = length(var.app_names)
  name               = "${var.environment}-${var.app_names[count.index]}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_threshold
    scale_in_cooldown  = 300
    scale_out_cooldown = 150
  }
}

# Alarmas de CloudWatch para monitoreo
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  count               = length(var.app_names)
  alarm_name          = "${var.environment}-${var.app_names[count.index]}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "CPU utilization high"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app[count.index].name
  }
  
  alarm_actions = [aws_appautoscaling_policy.ecs_policy_cpu[count.index].arn]
}

# Datos de la región actual
data "aws_region" "current" {}

