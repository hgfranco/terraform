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

variable "ami_id" {
  description = "Reviewed Ubuntu Server AMI ID for the cluster nodes."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the cluster nodes."
  type        = string
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name; no private key is supplied."
  type        = string
}

variable "admin_ipv4_cidr" {
  description = "Public IPv4 address allowed to access SSH, with /32."
  type        = string

  validation {
    condition = (
      can(cidrnetmask(var.admin_ipv4_cidr)) &&
      can(regex("/32$", var.admin_ipv4_cidr))
    )
    error_message = "Provide a single IPv4 address followed by /32."
  }
}

variable "worker_count" {
  description = "Number of worker nodes, in addition to one control-plane node."
  type        = number

  validation {
    condition = (
      var.worker_count >= 1 &&
      floor(var.worker_count) == var.worker_count
    )
    error_message = "worker_count must be a positive whole number."
  }
}

variable "root_volume_size_gib" {
  description = "Root disk size in GiB for each node."
  type        = number

  validation {
    condition = (
      var.root_volume_size_gib >= 20 &&
      floor(var.root_volume_size_gib) == var.root_volume_size_gib
    )
    error_message = "Provide a whole-number disk size of at least 20 GiB."
  }
}

variable "container_repository_name" {
  description = "ECR repository name for the application container images."
  type        = string
}