module "dns" {
  source         =  "../module" 
  prefix         = var.prefix
  location       = var.location
  dns_zone_name  = var.dns_zone_name
}
