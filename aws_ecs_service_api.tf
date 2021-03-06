# ------------------------------------------------------------------------------
# ECS Service - Ethereum Indexer API
# ------------------------------------------------------------------------------
resource "aws_ecs_service" "api" {
  name            = local.api_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"

  desired_count = var.api_instance_count

  health_check_grace_period_seconds = 120

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = local.api_task_name
    container_port   = var.api_container_port
  }

  network_configuration {
    subnets = data.terraform_remote_state.vpc.outputs.private_subnets
    security_groups = [
      data.terraform_remote_state.vpc.outputs.sg_http_8080_id # port 8080
    ]
    assign_public_ip = true
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Task Definition
# ------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "api" {
  family = local.api_service_name

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  memory = var.api_container_memory_alloc
  cpu    = var.api_container_cpu_alloc

  tags = local.tags

  container_definitions = format("[%s]", join(",", [
    "${local.api_def}"
  ]))
}

# ------------------------------------------------------------------------------
# Load Balancer
# ------------------------------------------------------------------------------
resource "aws_alb" "api" {
  name               = local.api_service_name
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnets

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_http_80_id # port 80
  ]

  internal = false

  # enable_cross_zone_load_balancing = "true"

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Listener / Target Group
# ------------------------------------------------------------------------------
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_alb.api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_target_group" "api" {
  name        = "chain-${local.api_service_name}"
  port        = var.api_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "ip"

  depends_on = [aws_alb.api]

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30 # seconds
    timeout             = 10 # seconds
    matcher             = "200"
    path                = var.api_health_check_path
    port                = var.api_container_port
  }

  tags = local.tags
}
