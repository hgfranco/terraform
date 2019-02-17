data "aws_route53_zone" "all" {}

output "zones" {
  value = "${aws_route53_zone.all.zone_id}"
}
