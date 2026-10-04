module "network" {
  source = "../../modules/network"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "kubeadm_cluster" {
  source = "../../modules/kubeadm_cluster"

  name                 = var.name
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.public_subnet_ids[var.availability_zones[0]]
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  ssh_key_name         = var.ssh_key_name
  admin_ipv4_cidr      = var.admin_ipv4_cidr
  worker_count         = var.worker_count
  root_volume_size_gib = var.root_volume_size_gib
}