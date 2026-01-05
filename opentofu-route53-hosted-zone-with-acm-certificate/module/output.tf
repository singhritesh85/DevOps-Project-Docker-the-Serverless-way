output "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone."
  value       = aws_route53_zone.hosted_zone.zone_id
}

output "hosted_zone_name_servers" {
  description = "The name servers for the Route 53 Hosted Zone."
  value       = aws_route53_zone.hosted_zone.name_servers
}

output "certificate_arn" {
  description = "The AWS ACM Certificate ARN"
  value = aws_acm_certificate.acm_cert.arn
}
