# Cluster ECS
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.environment}-cluster"
    Environment = var.environment
  }
}

# Roles IAM para ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-ecs-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-ecs-task-role"
    Environment = var.environment
  }
}

# CloudWatch Logs
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

# Task Definitions
resource "aws_ecs_task_definition" "app" {
  count                    = length(var.app_names)
  family                   = "${var.environment}-${var.app_names[count.index]}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  
  container_definitions = jsonencode([
    {
      name        = var.app_names[count.index]
      image       = "${var.ecr_repositories[count.index]}:latest"
      essential   = true
      
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
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      environment = []
      secrets     = []
    }
  ])
  
  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
}

# ECS Services
resource "aws_ecs_service" "app" {
  count           = length(var.app_names)
  name            = "${var.environment}-${var.app_names[count.index]}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app[count.index].arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 60
  
  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_tasks_security_group]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.target_groups[count.index]
    container_name   = var.app_names[count.index]
    container_port   = 8080
  }
  
  deployment_controller {
    type = "ECS"
  }
  
  tags = {
    Name        = "${var.environment}-${var.app_names[count.index]}"
    Environment = var.environment
    Application = var.app_names[count.index]
  }
  
  lifecycle {
    ignore_changes = [desired_count]
  }
}

# Auto Scaling
resource "aws_appautoscaling_target" "ecs_target" {
  count              = length(var.app_names)
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app[count.index].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

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
    scale_out_cooldown = 300
  }
}