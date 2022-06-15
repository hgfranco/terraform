variable "aws_subnet_id" {
  description = "ID of the specific subnet to retrieve"
}

variable "ec2_instance_count" {
  description = "Instance count"
}

variable "ec2_instance_ami_id" {
  description = "EC2 AMI ID"
}

variable "ec2_instance_type" {
  description = "Instance type"
}

variable "ec2_vpc_security_group_ids" {
  description = "Security Group ID"
}

variable "ec2_user_data" {
  description = "User data to provide when launching the instance"
}

variable "ec2_key_name" {
  description = "Key name of the Key Pair to use for the instance"
}

variable "ec2_instance_name" {
  description = "Instance name"
}

variable "ec2_service" {
  description = "Service name"
}

variable "ec2_environment" {
  description = "Name of environment"
}

variable "aws_instance_profile_name" {
  description = "The friendly IAM instance profile name to match."
}
