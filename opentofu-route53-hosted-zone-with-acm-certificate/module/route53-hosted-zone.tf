###################################################### Route53 Hosted Zone #######################################################

resource "aws_route53_zone" "hosted_zone" {
  name = var.name
  comment = "Public"

  tags = {
    Environment = var.env
  }
}
