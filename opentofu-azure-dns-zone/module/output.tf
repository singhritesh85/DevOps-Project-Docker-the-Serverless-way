output "dns_zone_name" {
  description = "The name of the Azure DNS Zone."
  value       = azurerm_dns_zone.dns_zone.name
}

output "name_servers" {
  description = "The list of name servers for the Azure DNS Zone."
  value       = azurerm_dns_zone.dns_zone.name_servers
}
