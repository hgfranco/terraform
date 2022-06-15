variable "random_password_length" {
  type        = number
  description = "The length of the string desired"
}

variable "random_password_min_upper" {
  type        = number
  description = "Minimum number of uppercase alphabet characters in the result"
}

variable "random_password_min_lower" {
  type        = number
  description = "Minimum number of lowercase alphabet characters in the result"
}

variable "random_password_upper" {
  type        = bool
  description = "Include uppercase alphabet characters in the resul"
}

variable "random_password_lower" {
  type        = bool
  description = "Include lowercase alphabet characters in the result"
}

variable "random_password_number" {
  type        = bool
  description = "Include numeric characters in the result"
}

variable "random_password_min_numeric" {
  type        = number
  description = "Minimum number of numeric characters in the result"
}

variable "random_password_min_special" {
  type        = number
  description = "Minimum number of special characters in the result"
}

variable "random_password_override_special" {
  description = "Supply your own list of special characters to use for string generation"
}

variable "random_password_special" {
  type        = bool
  description = "Include special characters in the result"
}

variable "random_password_keepers_pass_version" {
  description = "Arbitrary map of values that, when changed, will trigger recreation of resource"

}

