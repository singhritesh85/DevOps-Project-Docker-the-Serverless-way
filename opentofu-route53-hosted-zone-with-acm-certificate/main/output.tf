output "route53_hosted_zone_details" {
  description = "Route53 Hosted Zone ID, Nameserver and ACM Certificate ARN"
  value       = "${module.route53_hosted_zone}"
}
