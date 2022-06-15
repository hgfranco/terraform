# output "this_ec2_instance_id" {
#   description = "The EC2 instance ID"
#   value       = element(concat(aws_instance.create_ec2.*.id, [""]), 0)
# }

# output "this_ec2_instance_network_interface_id" {
#   description = "The EC2 instance network interface ID"
#   value       = element(concat(aws_instance.create_ec2.*.primary_network_interface_id, [""]), 0)
# }