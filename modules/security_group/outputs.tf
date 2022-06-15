output "this_sg_id" {
  description = "The security group ID"
  value = element(concat(aws_security_group.create_security_group.*.id, [""]),0,)
}
