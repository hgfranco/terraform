variable "ecs_cluster_name" {
  description = "Name of the cluster"
}

variable "ecs_task_definition_family" {
  description = "A unique name for your task definition"
}

variable "ecs_task_definition_requires_compatibilities" {
  description = "Set of launch types required by the task"
}

variable "ecs_task_definition_cpu" {
  description = "Number of cpu units used by the task"
}

variable "ecs_task_definition_memory" {
  description = "Amount (in MiB) of memory used by the task"
}

variable "ecs_container_definitions_name" {
  description = "The name of the container definition"
}

variable "ecs_container_definitions_image" {
  description = "The docker image in use"
}

variable "ecs_container_definitions_cpu" {
  description = "The CPU limit for this container definition"
}

variable "ecs_portMappsings_protocol" {
  description = "Port mapping protocol"
}

variable "ecs_portMappsings_containerPort" {
  description = "Container port"
}

variable "ecs_portMappsings_hostPort" {
  description = "Host port"
}

variable "ecs_service_name" {
  description = "Name of the service"
}

variable "ecs_service_desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to 0"
}