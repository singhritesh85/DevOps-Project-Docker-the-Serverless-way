# Create Resource Group
resource "azurerm_resource_group" "aca_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Create VNet for AKS
resource "azurerm_virtual_network" "aca_vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.aca_rg.name
  location            = azurerm_resource_group.aca_rg.location
  address_space       = ["172.16.0.0/16"]
}

# Create Subnet for VNet of Azure Container Applications
resource "azurerm_subnet" "aca_subnet" {
  name                 = "default"         ###"${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.aca_rg.name
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.Storage"]
  virtual_network_name = azurerm_virtual_network.aca_vnet.name
  address_prefixes     = ["172.16.0.0/24"]
  depends_on = [azurerm_virtual_network.aca_vnet]
}
