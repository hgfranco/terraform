output "this_random_password_result" {
  description = "The random password result"
  value       = element(concat(random_password.create_password.*.result, [""]), 0)
}

