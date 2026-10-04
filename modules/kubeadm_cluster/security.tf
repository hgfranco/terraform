resource "aws_security_group" "nodes" {
  name_prefix = "${var.name}-nodes-"
  description = "Network access for kubeadm cluster nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-nodes"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.nodes.id
  description       = "SSH from the administrator address"
  cidr_ipv4         = var.admin_ipv4_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "between_nodes" {
  security_group_id            = aws_security_group.nodes.id
  description                  = "Private communication between cluster nodes"
  referenced_security_group_id = aws_security_group.nodes.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.nodes.id
  description       = "Outbound IPv4 access"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}