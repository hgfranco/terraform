# Create ECS Cluster
resource "aws_ecs_cluster" "create_ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "create_ecs_task" {
  family                   = var.ecs_task_definition_family
  requires_compatibilities = [var.ecs_task_definition_requires_compatibilities]
  cpu                      = var.ecs_task_definition_cpu
  memory                   = var.ecs_task_definition_memory

  container_definitions = jsonencode([
    {
      name      = var.ecs_container_definitions_name
      image     = var.ecs_container_definitions_image
      cpu       = var.ecs_container_definitions_cpu
      essential = true
      portMappings = [
        {
          protocol      = var.ecs_portMappsings_protocol
          containerPort = var.ecs_portMappsings_containerPort
          hostPort      = var.ecs_portMappsings_hostPort
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "create_ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.create_ecs_cluster.id
  task_definition = aws_ecs_task_definition.create_ecs_task.arn
  desired_count   = var.ecs_service_desired_count
}
