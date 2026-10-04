output "nodes" {
  description = "Cluster node IDs, addresses, and roles."
  value       = module.kubeadm_cluster.nodes
}