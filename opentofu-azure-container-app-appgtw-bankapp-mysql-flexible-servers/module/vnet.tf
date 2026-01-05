######################################## Create Azure VNet #####################################
resource "azurerm_virtual_network" "aca_vnet" {
  name                = "${var.prefix}-virtual-network"
  location            = azurerm_resource_group.aca_rg.location
  resource_group_name = azurerm_resource_group.aca_rg.name
  address_space       = ["10.10.0.0/16"]
  tags = {
    Environment = var.env
  }
}

######################################### Create Azure Subnet###################################
resource "azurerm_subnet" "azure_container_apps" {
  name                 = "containerapps-subnet"
  resource_group_name  = azurerm_resource_group.aca_rg.name
  virtual_network_name = azurerm_virtual_network.aca_vnet.name
  address_prefixes     = ["10.10.0.0/23"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

######################## Create Subnet for VNet of Application Gateway #########################
resource "azurerm_subnet" "appgtw_subnet" {
  name                 = "subnet-1"         ###"${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.aca_rg.name
#  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.Storage"]
  virtual_network_name = azurerm_virtual_network.aca_vnet.name
  address_prefixes     = ["10.10.32.0/20"]
  private_link_service_network_policies_enabled = false
}

####################### Create Subnet for MySQL Flexible Servers ###############################
resource "azurerm_subnet" "mysql_flexible_server_subnet" {
  name                 = "${var.prefix}-mysql-flexible-server-subnet"
  resource_group_name  = azurerm_resource_group.aca_rg.name
  virtual_network_name = azurerm_virtual_network.aca_vnet.name
  address_prefixes     = ["10.10.16.0/20"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

#resource "azurerm_network_security_group" "aca_nsg" {
#  name                = "aca_nsg"
#  location            = azurerm_resource_group.aca_rg.location
#  resource_group_name = azurerm_resource_group.aca_rg.name

#  security_rule {
#    name                       = "allow_aca_sg"
#    priority                   = 100
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_ranges     = [80, 443]
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }


#}

############# NSG has been created and attached to Subnet However It is also possible to create and attach a NSG at Network Interface (NIC) ###############

#resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association1" {
#  subnet_id                 = azurerm_subnet.azure_container_apps.id
#  network_security_group_id = azurerm_network_security_group.aca_nsg.id
#}
