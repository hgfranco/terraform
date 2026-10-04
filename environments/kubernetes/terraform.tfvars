# network variables
name                 = "kubernetes"
vpc_cidr             = "10.42.0.0/16"
availability_zones   = ["us-east-1a"]
public_subnet_cidrs  = ["10.42.1.0/24"]
private_subnet_cidrs = []

# kubeadm_cluster variables
ami_id               = "ami-0045d7fc2ad003464"
instance_type        = "t3.medium"
ssh_key_name         = "FrancoTech"
worker_count         = 2
root_volume_size_gib = 20
admin_ipv4_cidr      = "73.193.219.6/32"