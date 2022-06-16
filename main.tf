# Define AWS region
provider "aws" {
  region = var.aws_region
}

# Configure the terraform S3 backend to store state
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "franco-docker-service/terraform.tfstate"
    region = "us-east-1"
  }
}

# Build the Security group resource
module "build_securitygroup" {
  source                    = "./modules/security_group/"
  aws_vpc_id                = var.aws_vpc_id
  securitygroup_name        = var.securitygroup_name
  securitygroup_description = var.securitygroup_description
  securitygroup_tag         = var.securitygroup_tag
  securitygroup_tcp_ports   = var.securitygroup_tcp_ports
  securitygroup_tcp_cidrs   = var.securitygroup_tcp_cidrs
  securitygroup_icmp_cidrs  = var.securitygroup_icmp_cidrs
  securitygroup_udp_ports   = var.securitygroup_udp_ports
  securitygroup_udp_cidrs   = var.securitygroup_udp_cidrs
  securitygroup_all_cidrs   = var.securitygroup_all_cidrs
}

# Build the EC2 instance resource
module "build_ec2" {
  source                     = "./modules/ec2/"
  aws_subnet_id              = var.aws_subnet_id
  ec2_instance_count         = var.ec2_instance_count
  ec2_instance_ami_id        = var.ec2_instance_ami_id
  ec2_instance_type          = var.ec2_instance_type
  ec2_vpc_security_group_ids = module.build_securitygroup.this_sg_id
  ec2_user_data              = var.ec2_user_data
  ec2_key_name               = var.ec2_key_name
  ec2_instance_name          = var.ec2_instance_name
  ec2_service                = var.ec2_service
  ec2_environment            = var.ec2_environment
  aws_instance_profile_name  = var.aws_instance_profile_name
}

# Build the Elastic Cluster resource
module "build_ecs" {
  source                                       = "./modules/ecs/"
  ecs_cluster_name                             = var.ecs_cluster_name
  ecs_task_definition_family                   = var.ecs_task_definition_family
  ecs_task_definition_requires_compatibilities = var.ecs_task_definition_requires_compatibilities
  ecs_task_definition_cpu                      = var.ecs_task_definition_cpu
  ecs_task_definition_memory                   = var.ecs_task_definition_memory
  ecs_container_definitions_name               = var.ecs_container_definitions_name
  ecs_container_definitions_image              = var.ecs_container_definitions_image
  ecs_container_definitions_cpu                = var.ecs_container_definitions_cpu
  ecs_portMappsings_protocol                   = var.ecs_portMappsings_protocol
  ecs_portMappsings_containerPort              = var.ecs_portMappsings_containerPort
  ecs_portMappsings_hostPort                   = var.ecs_portMappsings_hostPort
  ecs_service_name                             = var.ecs_service_name
  ecs_service_desired_count                    = var.ecs_service_desired_count
}

# Build the Elastic IP resource
module "build_eip" {
  source                = "./modules/eip/"
  eip_instance          = module.build_ec2.this_ec2_instance_id
  eip_network_interface = module.build_ec2.this_ec2_instance_network_interface_id
}

# Build Route53 resource
module "build_route53" {
  source          = "./modules/route53/"
  route53_zoneid  = var.route53_zoneid
  route53_name    = module.build_ec2.this_ec2_instance_name
  route53_type    = var.route53_type
  route53_ttl     = var.route53_ttl
  route53_records = module.build_eip.this_eip_address
}
