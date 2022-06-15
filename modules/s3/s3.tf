resource "aws_s3_bucket" "create_bucket" {
  bucket = var.s3_bucket_name

  force_destroy = var.s3_bucket_force_destroy


  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "create_s3_bucket_lifecyle" {

  bucket = aws_s3_bucket.create_bucket.id

  rule {
    id     = var.s3_bucket_lifecycle_id
    status = var.s3_bucket_lifecycle_status

    filter {
      and {
        tags = {
          (var.s3_bucket_lifecycle_tag_key) = (var.s3_bucket_lifecycle_tag_value)
        }
      }
    }

    expiration {
      days = var.s3_bucket_lifecycle_days
    }
  }
}
