output "this_eip_address" {
  description = "The elastic IP address"
  value       = element(concat(aws_eip.set_eip.*.public_ip, [""]), 0)
}
