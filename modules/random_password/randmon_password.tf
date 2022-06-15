resource "random_password" "create_password" {
  length      = var.random_password_length
  min_upper   = var.random_password_min_upper
  min_lower   = var.random_password_min_lower
  upper       = var.random_password_upper
  lower       = var.random_password_lower
  number      = var.random_password_number
  min_numeric = var.random_password_min_numeric
  min_special = var.random_password_min_special

  override_special = var.random_password_override_special
  special          = var.random_password_special

  keepers = {
    pass_version = var.random_password_keepers_pass_version
  }
}
