output "this_s3_bucket_id" {
  description = "The S3 bucket ID"
  value       = element(concat(aws_s3_bucket.create_bucket.*.id, [""]), 0)
}
