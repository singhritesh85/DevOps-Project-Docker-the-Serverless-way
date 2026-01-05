resource "azurerm_private_dns_zone" "dexter_private_mysql" {
  name                = "dexter-mysql.private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.aca_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dexter_mysql_vnet_link" {
  name                  = "demoprivate.com"
  private_dns_zone_name = azurerm_private_dns_zone.dexter_private_mysql.name
  virtual_network_id    = azurerm_virtual_network.aca_vnet.id
  resource_group_name   = azurerm_resource_group.aca_rg.name
  depends_on            = [azurerm_subnet.mysql_flexible_server_subnet]
}

resource "azurerm_mysql_flexible_server" "azure_mysql" {
  name                   = "dexter-mysql3"
  resource_group_name    = azurerm_resource_group.aca_rg.name
  location               = azurerm_resource_group.aca_rg.location
  version                = "8.4"
  administrator_login    = "adminuser"
  administrator_password = var.MYSQL_ROOT_PASSWORD
#  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.mysql_flexible_server_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.dexter_private_mysql.id
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"  

  storage {
    auto_grow_enabled = false
    io_scaling_enabled = false
    iops = 360
    size_gb = 20
  }
  
#  high_availability {
#    mode = "ZoneRedundant"
#    standby_availability_zone = 3
#  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dexter_mysql_vnet_link]
}

resource "azurerm_mysql_flexible_database" "bankapp_db" {
  name                = "bankappdb"
  resource_group_name = azurerm_resource_group.aca_rg.name
  server_name         = azurerm_mysql_flexible_server.azure_mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  lifecycle {
    ignore_changes = [charset, collation]
  }
}

resource "azurerm_mysql_flexible_server_configuration" "secure_transport_off" {
  name                = "require_secure_transport"
  server_name         = azurerm_mysql_flexible_server.azure_mysql.name
  resource_group_name = azurerm_mysql_flexible_server.azure_mysql.resource_group_name
  value               = "OFF"
  depends_on          = [azurerm_mysql_flexible_database.bankapp_db]
}
