output "nodes" {
  description = "Instance IDs and addresses, keyed by node name."
  value = {
    for name, node in aws_instance.node : name => {
      instance_id = node.id
      private_ip  = node.private_ip
      public_ip   = node.public_ip
      role        = local.nodes[name].role
    }
  }
}

output "control_plane_private_ip" {
  description = "Private address to use for the kubeadm control-plane endpoint."
  value       = aws_instance.node["control"].private_ip
}

output "security_group_id" {
  description = "Security group attached to the cluster nodes."
  value       = aws_security_group.nodes.id
}