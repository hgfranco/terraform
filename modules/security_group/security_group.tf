# Create Security Group
resource "aws_security_group" "create_security_group" {
  name        = var.securitygroup_name
  description = var.securitygroup_description
  vpc_id      = var.aws_vpc_id

  tags = {
    Name = var.securitygroup_tag
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
  security_group_id = aws_security_group.create_security_group.id
}

# Create TCP SG rules
resource "aws_security_group_rule" "tcp" {
  count             = length(var.securitygroup_tcp_ports)
  type              = "ingress"
  from_port         = var.securitygroup_tcp_ports[count.index]
  to_port           = var.securitygroup_tcp_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [var.securitygroup_tcp_cidrs[count.index]]
  description       = ""
  security_group_id = aws_security_group.create_security_group.id
}

# Create UDP SG rules
resource "aws_security_group_rule" "udp" {
  count             = length(var.securitygroup_udp_ports)
  type              = "ingress"
  from_port         = var.securitygroup_udp_ports[count.index]
  to_port           = var.securitygroup_udp_ports[count.index]
  protocol          = "udp"
  cidr_blocks       = [var.securitygroup_udp_cidrs[count.index]]
  description       = ""
  security_group_id = aws_security_group.create_security_group.id
}

# Create ICMP SG rules
resource "aws_security_group_rule" "icmp" {
  count             = length(var.securitygroup_icmp_cidrs)
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = [var.securitygroup_icmp_cidrs[count.index]]
  description       = ""
  security_group_id = aws_security_group.create_security_group.id
}

# Create ALL SG rules
resource "aws_security_group_rule" "all" {
  count             = length(var.securitygroup_all_cidrs)
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  cidr_blocks       = [var.securitygroup_all_cidrs[count.index]]
  description       = ""
  security_group_id = aws_security_group.create_security_group.id
}
