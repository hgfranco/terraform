variable "aws_profile" {
  description = "AWS Profile"
  default = "francotech"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID to used"
  default = "vpc-cc1d43a9"
}

variable "sg_name" {
  description = "Secrurity Group"
  default = "Nexus-SG"
}

variable "sg_description" {
  description = "Secrurity Group description"
  default = "Nexus Secruity Group"
}

variable "sg_tag" {
  description = "Security Group tag"
  default = "Nexus Secrurity Group"
}

variable "instance_count" {
  description = "Instance count"
  default = "1"
}

variable "instance_ami_id" {
  description = "EC2 AMI ID"
  default = "ami-05a3ee48e4b7a3d66"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.medium"
} 

variable "instance_subnet_id" {
  description = "Instance subnet ID"
  default = "subnet-6060ee39"
}

variable "instance_key_name" {
  description = "Key to be used for login"
  default = "FrancoTech"
}

variable "environment" {
  description = "Name of environment"
  default = "production"
}

variable "environment_short" {
  description = "Short name of environment"
  default = "p"
}

variable "route_53_zone_id" {
  description = "Zone ID"
  default = "Z2XY6P7GE0KIEK"
}

variable "vpc_tag_lookup" {
  description = "Lookup VPC tag"
  default = "*FrancoTech*"
}

variable "tl_domain_name" {
  description = "Top Level Domain Name"
  default = "henryfranco.com"
}

variable "app_name" {
  description = "Application name"
  default = "nexus-repo"
}

variable "service" {
  description = "Service name"
  default = "nexus"
}

variable "tcp_ports" {
  description = "Security group TCP ports"
  default = "22,80"
}

variable "udp_ports" {
  description = "Security group UDP ports"
  default = "default_null"
}

variable "cidrs" {
  type = "list"
  default = [
    "0.0.0.0/0"
  ]
}