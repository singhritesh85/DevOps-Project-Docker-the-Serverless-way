output "azure_dns_zone_name_and_nameserver" {
  description = "Azure DNS Zone Name and Nameserver"
  value       = "${module.dns}"
}
