module "route53_hosted_zone" {

  source = "../module"
  name = var.name
  env = var.env[0]

}
