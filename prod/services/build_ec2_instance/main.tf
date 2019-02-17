provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

# Provides a list of subnet IDs for vpc_id
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.vpc_tag_lookup}"
  }
}

// Create Security Group for EC2 instances
resource "aws_security_group" "create_security_group" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.sg_tag}"
  }
}

// Create EC2 instances
resource "aws_instance" "build_ec2" {
  count                  = "${var.instance_count}"
  ami                    = "${var.instance_ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.instance_subnet_id}"
  key_name               = "${var.instance_key_name}"
  vpc_security_group_ids = ["${aws_security_group.create_security_group.id}"]

  tags {
    Name        = "${var.app_name}0${count.index + 1}.${var.environment_short}.${var.tl_domain_name}"
    service     = "${var.service}"
    environment = "${var.environment}"
  }
}

// Create a A record for the EC2 instance
resource "aws_route53_record" "create_route53_cname" {
  zone_id = "${var.route_53_zone_id}"
  name    = "${var.app_name}0${count.index + 1}.${var.environment_short}.${var.tl_domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.build_ec2.public_ip}"]
}