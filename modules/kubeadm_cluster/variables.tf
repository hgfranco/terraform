variable "name" {
  description = "Prefix for cluster resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the cluster security groups will be created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet where the control-plane and worker nodes will run."
  type        = string
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

variable "instance_profile_name" {
  description = "IAM instance profile attached to the cluster nodes."
  type        = string
  default     = null
}