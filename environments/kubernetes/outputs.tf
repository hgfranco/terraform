output "nodes" {
  description = "Cluster node IDs, addresses, and roles."
  value       = module.kubeadm_cluster.nodes
}

output "container_repository_url" {
  description = "ECR repository URL for pushing and pulling application images."
  value       = module.ecr.repository_url
}