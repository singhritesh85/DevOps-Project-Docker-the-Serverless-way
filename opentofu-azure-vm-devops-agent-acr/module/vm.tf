############################################## Creation for NSG for Azure DevOps Agent #######################################################

resource "azurerm_network_security_group" "azure_nsg_devopsagent" {
#  count               = var.vm_count_rabbitmq
  name                = "devopsagent-nsg"
  location            = azurerm_resource_group.aca_rg.location
  resource_group_name = azurerm_resource_group.aca_rg.name

  security_rule {
    name                       = "devopsagent_ssh_azure"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "azure_nsg_node_exporter"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefixes      = ["10.224.0.0/12"]
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface for Azure DevOps Agent #############################################

resource "azurerm_public_ip" "public_ip_devopsagent" {
#  count               = var.vm_count_rabbitmq
  name                = "devopsagent-ip"
  resource_group_name = azurerm_resource_group.aca_rg.name
  location            = azurerm_resource_group.aca_rg.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface_devopsagent" {
#  count               = var.vm_count_rabbitmq
  name                = "devopsagent-nic"
  location            = azurerm_resource_group.aca_rg.location
  resource_group_name = azurerm_resource_group.aca_rg.name

  ip_configuration {
    name                          = "devopsagent-ip-configuration"
    subnet_id                     = azurerm_subnet.aca_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip_devopsagent.id
  }

  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface for Azure DevOps Agent #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic" {
#  count                     = var.vm_count_rabbitmq
  network_interface_id      = azurerm_network_interface.vnet_interface_devopsagent.id
  network_security_group_id = azurerm_network_security_group.azure_nsg_devopsagent.id

}

######################################################## Create Azure VM for Azure DevOps Agent ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm_devopsagent" {
#  count                 = var.vm_count_rabbitmq
  name                  = "devopsagent-vm"
  location              = azurerm_resource_group.aca_rg.location
  resource_group_name   = azurerm_resource_group.aca_rg.name
  network_interface_ids = [azurerm_network_interface.vnet_interface_devopsagent.id]
  size                  = var.vm_size
  zone                 = var.availability_zone[0]
  computer_name  = "devopsagent-vm"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data_devopsagent.sh")
  disable_password_authentication = false

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    storage_account_uri  = ""
  }

  source_image_reference {
    publisher = "almalinux"      ###"OpenLogic"
    offer     = "almalinux-x86_64"      ###"CentOS"
    sku       = "8-gen2"         ###"7_9-gen2"
    version   = "latest"         ###"latest"
  }
  os_disk {
    name              = "devopsagent-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

#  identity {
#    type         = "UserAssigned"
#    identity_ids = [azurerm_user_assigned_identity.bankapp_uai.id]
#  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_managed_disk.disk_devopsagent]

}

resource "azurerm_managed_disk" "disk_devopsagent" {
#  count                = var.vm_count_rabbitmq
  name                 = "devopsagent-datadisk"
  location             = azurerm_resource_group.aca_rg.location
  resource_group_name  = azurerm_resource_group.aca_rg.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment_devopsagent" {
#  count              = var.vm_count_rabbitmq
  managed_disk_id    = azurerm_managed_disk.disk_devopsagent.id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm_devopsagent.id
  lun                = "0"
  caching            = "ReadWrite"
}
