resource "azurerm_resource_group" "dns_rg" {
  name     = "${var.prefix}-rosource-group"
  location = var.location[0]
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.dns_rg.name
}

