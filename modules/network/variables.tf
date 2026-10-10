variable "name" {
  description = "Prefix for network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 address range for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  description = "Availability zones, ordered to match the subnet CIDR lists."
  type        = list(string)

  validation {
    condition = (
      length(var.availability_zones) > 0 &&
      length(distinct(var.availability_zones)) == length(var.availability_zones)
    )
    error_message = "Provide at least one availability zone, with no duplicates."
  }
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per availability zone, in matching order."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr))
      ])
    )
    error_message = "Provide one valid IPv4 public subnet CIDR per availability zone."
  }
}

variable "private_subnet_cidrs" {
  description = "Optional private subnets: none, or one per availability zone."
  type        = list(string)
  default     = []

  validation {
    condition = (
      contains([0, length(var.availability_zones)], length(var.private_subnet_cidrs)) &&
      alltrue([
        for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr))
      ])
    )
    error_message = "Provide no private subnets, or one valid IPv4 CIDR per availability zone."
  }
}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets, including load-balancer discovery tags."
  type        = map(string)
  default     = {}
}
