# Provides a list of subnet IDs for vpc_id
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.vpc_tag_lookup}"
  }
}

# Create Security Group for EC2 instances
resource "aws_security_group" "create_security_group" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.sg_tag}"
  }
}

# Create egress SG rule 
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = "${aws_security_group.create_security_group.id}"
}

# For reference 
# https://stackoverflow.com/questions/50642635/how-to-keep-usage-of-terraform-aws-security-group-dry
# Create TCP SG rules
resource "aws_security_group_rule" "tcp" {
  count             = "${var.tcp_ports == "default_null" ? 0 : length(split(",", var.tcp_ports))}"
  type              = "ingress"
  from_port         = "${element(split(",", var.tcp_ports), count.index)}"
  to_port           = "${element(split(",", var.tcp_ports), count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.cidrs}"]
  description       = ""
  security_group_id = "${aws_security_group.create_security_group.id}"
}

# Create UDP SG rules
resource "aws_security_group_rule" "udp" {
  count             = "${var.udp_ports == "default_null" ? 0 : length(split(",", var.udp_ports))}"
  type              = "ingress"
  from_port         = "${element(split(",", var.udp_ports), count.index)}"
  to_port           = "${element(split(",", var.udp_ports), count.index)}"
  protocol          = "udp"
  cidr_blocks       = ["${var.cidrs}"]
  description       = ""
  security_group_id = "${aws_security_group.create_security_group.id}"
}

# Create EC2 instances
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

# Create a A record for the EC2 instance
resource "aws_route53_record" "create_route53_cname" {
  zone_id = "${var.route_53_zone_id}"
  name    = "${var.app_name}0${count.index + 1}.${var.environment_short}.${var.tl_domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.build_ec2.public_ip}"]
}