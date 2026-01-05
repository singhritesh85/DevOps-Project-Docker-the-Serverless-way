resource "azurerm_private_dns_zone" "main" {
  name                = azurerm_container_app_environment.aca_environment.default_domain
  resource_group_name = azurerm_resource_group.aca_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "${azurerm_virtual_network.aca_vnet.name}-link"
  resource_group_name   = azurerm_resource_group.aca_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.aca_vnet.id
}

resource "azurerm_private_dns_a_record" "main" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.main.name
  resource_group_name = azurerm_resource_group.aca_rg.name
  ttl                 = 3600
  records             = [azurerm_container_app_environment.aca_environment.static_ip_address]
}
