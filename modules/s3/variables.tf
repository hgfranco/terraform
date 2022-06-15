variable "s3_bucket_name" {
  description = "The name of the bucket"
}

variable "s3_bucket_force_destroy" {
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error"
}

variable "s3_bucket_lifecycle_id" {
  description = "Unique identifier for the rule"
}

variable "s3_bucket_lifecycle_status" {
  description = "Whether the rule is currently being applied"
}

variable "s3_bucket_lifecycle_tag_key" {
  description = "A configuration block for specifying a tag key and value"
}

variable "s3_bucket_lifecycle_tag_value" {
  description = "A configuration block for specifying a tag key and value"
}

variable "s3_bucket_lifecycle_days" {
  description = "Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker"
}
