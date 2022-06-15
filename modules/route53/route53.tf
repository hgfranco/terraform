# Create Route53 record
resource "aws_route53_record" "create_record" {
  zone_id = var.route53_zoneid
  name    = var.route53_name
  type    = var.route53_type
  ttl     = var.route53_ttl
  records = [var.route53_records]
}
