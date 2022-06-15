data "aws_iam_instance_profile" "instance_profile" {
  name = var.aws_instance_profile_name
}

data "aws_subnet" "subnet_id" {
  id = var.aws_subnet_id
}

resource "aws_launch_configuration" "create_launch_config" {
  image_id                    = var.launch_config_image_id
  key_name                    = var.launch_config_key_name
  associate_public_ip_address = var.launch_config_associate_public_ip_address
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.name
  security_groups             = [var.launch_config_aws_security_group]
  user_data                   = var.launch_config_user_data
  instance_type               = var.launch_config_instance_type
}

resource "aws_autoscaling_group" "create_autoscaling_group" {
  name                      = var.autoscaling_group_name
  vpc_zone_identifier       = [data.aws_subnet.subnet_id.id]
  launch_configuration      = aws_launch_configuration.create_launch_config.name
  desired_capacity          = var.autoscaling_group_desire_capacity
  min_size                  = var.autoscaling_group_min_size
  max_size                  = var.autoscaling_group_max_size
  health_check_grace_period = var.autoscaling_group_health_check_grace_period
  health_check_type         = var.autoscaling_group_health_check_type
}
