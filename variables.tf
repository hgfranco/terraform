# Global variables
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_vpc_id" {
  default = "vpc-xxxxxxxxxxx"
}

variable "aws_instance_profile_name" {
  default = "ecsInstanceRole"
}

variable "aws_subnet_id" {
  default = "subnet-xxxxxxxxxx"
}

# Security group variables
variable "securitygroup_name" {
  default = "docker-service-sg"
}

variable "securitygroup_description" {
  default = "Docker Service Security group"
}

variable "securitygroup_tag" {
  default = "docker-service-securitygroup"
}

variable "securitygroup_tcp_ports" {
  type    = list(string)
  default = ["8888"]
}

variable "securitygroup_tcp_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "securitygroup_udp_ports" {
  type    = list(string)
  default = []
}

variable "securitygroup_udp_cidrs" {
  type    = list(string)
  default = []
}

variable "securitygroup_all_cidrs" {
  type    = list(string)
  default = []
}

variable "securitygroup_icmp_cidrs" {
  type    = list(string)
  default = []
}

# Security group variables
variable "sg_name" {
  default = ""
}

variable "sg_description" {
  default = ""
}

variable "sg_tag" {
  default = ""
}

variable "sg_tcp_ports" {
  type    = list(string)
  default = []
}

variable "sg_tcp_cidrs" {
  type    = list(string)
  default = []
}

variable "sg_udp_ports" {
  type    = list(string)
  default = []
}

variable "sg_udp_cidrs" {
  type    = list(string)
  default = []
}

variable "sg_all_cidrs" {
  type    = list(string)
  default = []
}

variable "sg_icmp_cidrs" {
  type = list(string)

  default = []
}

# EC2 variables
variable "ec2_instance_count" {
  default = 1
}

variable "ec2_instance_ami_id" {
  default = "ami-0a5e7c9183d1cea27"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_vpc_security_group_ids" {
  default = ""
}

variable "ec2_user_data" {
  default = "#!/bin/bash\necho ECS_CLUSTER=docker-service-cluster >> /etc/ecs/ecs.config"
}

variable "ec2_key_name" {
  default = "devops"
}

variable "ec2_instance_name" {
  default = "ecs-docker-service"
}

variable "ec2_service" {
  default = "docker"
}

variable "ec2_environment" {
  default = "staging"
}

# ECS variables
variable "ecs_cluster_name" {
  default = "docker-service-cluster"
}

variable "ecs_task_definition_family" {
  default = "docker-service-family"
}

variable "ecs_task_definition_requires_compatibilities" {
  default = "EC2"
}

variable "ecs_task_definition_cpu" {
  default = 512
}

variable "ecs_task_definition_memory" {
  default = 256
}

variable "ecs_container_definitions_name" {
  default = "docker-service"
}

variable "ecs_container_definitions_image" {
  default = "xxxxxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/docker-service:latest"
}

variable "ecs_container_definitions_cpu" {
  default = 10
}

variable "ecs_portMappsings_protocol" {
  default = "tcp"
}

variable "ecs_portMappsings_containerPort" {
  default = 8080
}

variable "ecs_portMappsings_hostPort" {
  default = 8888
}

variable "ecs_service_name" {
  default = "docker-service"
}

variable "ecs_service_desired_count" {
  default = "1"
}

# EIP variables
variable "eip_instance" {
  default = ""
}

variable "eip_network_interface" {
  default = ""
}

# Route53 variables
variable "route53_zoneid" {
  default = "xxxxxxxxxxxxxx"
}

variable "route53_name" {
  default = ""
}

variable "route53_type" {
  default = "A"
}

variable "route53_ttl" {
  default = "300"
}

variable "route53_records" {
  default = ""
}
