################################# Security Group of BankApp Container #################################

resource "aws_security_group" "bankapp_container_access" {
 name        = "bankapp-container-access-${var.env}"
 description = "BankApp Port 8080 Access"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Allow Port 8080"
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   security_groups = [aws_security_group.ecs_alb.id]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

####################################### IAM Role for ECS ############################################

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_access" {
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel" 
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_access_policy" {
  name        = "SSM-Access-Policy-for-ECS"
  description = "SSM Access Policy for ECS"
  policy      = data.aws_iam_policy_document.ssm_access.json
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole-dexter"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_ssm" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_access_policy.arn
}

####################################### CloudWatch LogGroup #########################################

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.prefix}-log-group"
}

####################################### ECS Cluster #################################################

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.prefix}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
#      kms_key_id = var.kms_key_id
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = false   ###true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_log_group.name
      }
    }
    
#    managed_storage_configuration {
#      fargate_ephemeral_storage_kms_key_id = ""    ###var.kms_key_id
#      kms_key_id = var.kms_key_id
#    }
  }
}

########################################### ECS Task Definition BankApp #####################################

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${var.prefix}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions    = jsonencode([
  {
    name = "bankapp"
    image = "${var.REPO_NAME}:${var.TAG_NUMBER}"
    environment = [
      {
        name  = "JDBC_URL"
        value = "jdbc:mysql://${aws_db_instance.dbinstance2.endpoint}/bankappdb?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC"
      },
      {
        name  = "JDBC_PASS" 
        value = "Admin123"
      },
      {
        name  = "JDBC_USER"
        value = "admin"
      }
    ],
    essential = true
    portMappings = [
      {
        name     = "bankapp"
        containerPort = 8080
        hostPort = 8080
        protocol = "tcp"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
        "awslogs-region"        = data.aws_region.reg.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }
])
}

##################################################### ECS Service BankApp ########################################################

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.prefix}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  availability_zone_rebalancing = "ENABLED"
  launch_type = "FARGATE"
  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"
  enable_execute_command = true    ### Allow or not to login into your container
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent       = 200

  deployment_configuration {
    strategy = "ROLLING"
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "bankapp"
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.bankapp_container_access.id]
    subnets = aws_subnet.private_subnet.*.id 
  }

  depends_on = [aws_db_instance.dbinstance2]
}

##################################################### Autoscale BankApp Containers ######################################################

resource "aws_appautoscaling_target" "bankapp_to_target" {
  max_capacity = 3
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "bankapp_to_memory" {
  name               = "bankapp-container-to-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.bankapp_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.bankapp_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.bankapp_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "bankapp_to_cpu" {
  name               = "bankapp-container-to-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.bankapp_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.bankapp_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.bankapp_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 65
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "bankapp_to_http_request" {
  name               = "bankapp-container-to-http-request"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.bankapp_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.bankapp_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.bankapp_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.test-application-loadbalancer.arn_suffix}/${aws_lb_target_group.target_group.arn_suffix}"
    }

    target_value       = 100
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}
