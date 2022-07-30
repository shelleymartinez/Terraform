#main.tf

# Create ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "project_ecs"
}

# Create task definition with FARGATE
resource "aws_ecs_task_definition" "ecs" {
  family = "ecs"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 1024
  memory = 2048

  container_definitions = jsonencode([
    {
      requires_compatibilities = ["FARGATE"]
      cpu                      = 256
      image                    = "centos:latest"
      network_mode             = "awsvpc"
      memory                   = 512
      essential                = true
      name                     = "ecs"
      container_port           = 8080
    }
  ])
}

# Allow access to details of our specified task definition
data "aws_ecs_task_definition" "ecs" {
  task_definition = aws_ecs_task_definition.ecs.family
}

resource "aws_ecs_cluster_capacity_providers" "ecs_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "ecs_service"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = aws_ecs_task_definition.ecs.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }
}