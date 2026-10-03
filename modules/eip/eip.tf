# Create Elastic IP
resource "aws_eip" "set_eip" {
  domain            = true
  instance          = var.eip_instance
  network_interface = var.eip_network_interface
}
