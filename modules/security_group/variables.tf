# Security group variables
variable "aws_vpc_id" {
  description = "VPC ID to used"
}

variable "securitygroup_name" {
  description = "Secrurity Group"
}

variable "securitygroup_description" {
  description = "Secrurity Group description"
}

variable "securitygroup_tag" {
  description = "Security Group tag"
}

variable "securitygroup_tcp_ports" {
  type        = list(string)
  description = "Security group TCP ports"
}

variable "securitygroup_tcp_cidrs" {
  type        = list(string)
  description = "TCP CIDR"
}

variable "securitygroup_icmp_cidrs" {
  type        = list(string)
  description = "ICMP CIDR"
}

variable "securitygroup_udp_ports" {
  type        = list(string)
  description = "Security group UDP ports"
}

variable "securitygroup_udp_cidrs" {
  type        = list(string)
  description = "UDP CIDR"
}

variable "securitygroup_all_cidrs" {
  type        = list(string)
  description = "ALL CIDR"
}
