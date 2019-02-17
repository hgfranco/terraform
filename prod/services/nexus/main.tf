# Define AWS profile and region
provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

module "build_ec2" {
  source  = "../../../modules/ec2/"
  vpc_id  = "${var.vpc_id}"
  sg_description = "${var.sg_description}"
  vpc_tag_lookup = "${var.vpc_tag_lookup}"
  cidrs = "${var.cidrs}"
  app_name = "${var.app_name}"
  instance_key_name = "${var.instance_key_name}"
  environment = "${var.environment}"
  instance_type = "${var.instance_type}"
  udp_ports = "${var.udp_ports}"
  aws_profile = "${var.aws_profile}"
  sg_tag = "${var.sg_tag}"
  tcp_ports = "${var.tcp_ports}"
  service = "${var.service}"
  instance_count = "${var.instance_count}"
  aws_region = "${var.aws_region}"
  tl_domain_name = "${var.tl_domain_name}"
  environment_short = "${var.environment_short}"
  instance_subnet_id = "${var.instance_subnet_id}"
  route_53_zone_id = "${var.route_53_zone_id}"
  sg_name = "${var.sg_name}"
  instance_ami_id = "${var.instance_ami_id}"
}