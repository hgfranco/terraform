locals {
  nodes = merge(
    {
      control = {
        role = "control-plane"
      }
    },
    {
      for index in range(var.worker_count) :
      format("worker-%02d", index + 1) => {
        role = "worker"
      }
    }
  )
}

data "aws_key_pair" "ssh" {
  key_name = var.ssh_key_name
}

resource "aws_instance" "node" {
  for_each = local.nodes

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = data.aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  associate_public_ip_address = true
  disable_api_termination     = true

  user_data = <<-EOF
    #cloud-config
    hostname: ${var.name}-${each.key}
    manage_etc_hosts: localhost
  EOF

  user_data_replace_on_change = false

  root_block_device {
    volume_size           = var.root_volume_size_gib
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false
  }

  dynamic "credit_specification" {
    for_each = startswith(var.instance_type, "t3") ? [1] : []

    content {
      cpu_credits = "standard"
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.name}-${each.key}"
    Role = each.value.role
  }

  lifecycle {
    prevent_destroy = true
  }
}