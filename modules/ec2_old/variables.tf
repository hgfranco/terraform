variable "vpc_id" {
  description = "VPC ID to used"
}

variable "sg_name" {
  description = "Secrurity Group"
}

variable "sg_description" {
  description = "Secrurity Group description"
}

variable "sg_tag" {
  description = "Security Group tag"
}

variable "instance_count" {
  description = "Instance count"
}

variable "instance_ami_id" {
  description = "EC2 AMI ID"
}

variable "instance_type" {
  description = "Instance type"
} 

variable "instance_subnet_id" {
  description = "Instance subnet ID"
}

variable "instance_key_name" {
  description = "Key to be used for login"
}

variable "environment" {
  description = "Name of environment"
}

variable "environment_short" {
  description = "Short name of environment"
}

variable "route_53_zone_id" {
  description = "Zone ID"
}

variable "vpc_tag_lookup" {
  description = "Lookup VPC tag"
}

variable "tl_domain_name" {
  description = "Top Level Domain Name"
}

variable "app_name" {
  description = "Application name"
}

variable "service" {
  description = "Service name"
}

variable "tcp_ports" {
  description = "Security group TCP ports"
}

variable "udp_ports" {
  description = "Security group UDP ports"
}

variable "cidrs" {
  type = "list"
}