variable "aws_instance_profile_name" {
  description = "The friendly IAM instance profile name to match."
}

variable "aws_subnet_id" {
  description = "ID of the specific subnet to retrieve"
}

variable "launch_config_image_id" {
  description = "The EC2 image ID to launch"
}

variable "launch_config_key_name" {
  description = "The key name that should be used for the instance"
}

variable "launch_config_associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
}

variable "launch_config_aws_security_group" {
  description = "A list of associated security group IDS"
}

variable "launch_config_user_data" {
  description = "The user data to provide when launching the instance"
}

variable "launch_config_instance_type" {
  description = "The size of instance to launch"
}

variable "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
}

variable "autoscaling_group_desire_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "autoscaling_group_min_size" {
  description = "The minimum size of the Auto Scaling Group"
}

variable "autoscaling_group_max_size" {
  description = "The maximum size of the Auto Scaling Group"
}

variable "autoscaling_group_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
}

variable "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
}
