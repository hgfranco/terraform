# data "aws_vpc" "vpc_subnets" {
#   id = var.aws_vpc_id
# }

# resource "random_shuffle" "random_subnet" {
#   input        = [data.aws_vpc.vpc_subnets.id]
#   result_count = 1
# }

data "aws_iam_instance_profile" "instance_profile" {
  name = var.aws_instance_profile_name
}

data "aws_subnet" "subnet_id" {
  id = var.aws_subnet_id
}

# Create EC2 instance
resource "aws_instance" "create_ec2" {
  #subnet_id              = flatten(data.aws_subnet_ids.vpc_subnets.ids)[0]
  subnet_id              = var.aws_subnet_id
  ami                    = var.ec2_instance_ami_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [var.ec2_vpc_security_group_ids]
  user_data              = var.ec2_user_data
  key_name               = var.ec2_key_name
  iam_instance_profile   = data.aws_iam_instance_profile.instance_profile.name

  tags = {
    Name            = "${var.ec2_instance_name}"
    instance_record = var.ec2_instance_name
    service         = var.ec2_service
    environment     = var.ec2_environment
  }
}

