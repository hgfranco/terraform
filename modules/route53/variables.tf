variable "route53_zoneid" {
  description = "The ID of the hosted zone to contain this record"
}

variable "route53_name" {
  description = "The name of the record"
}

variable "route53_type" {
  description = "The record type"
}

variable "route53_ttl" {
  description = "The TTL of the record"
}

variable "route53_records" {
  description = "A string list of records"
}
