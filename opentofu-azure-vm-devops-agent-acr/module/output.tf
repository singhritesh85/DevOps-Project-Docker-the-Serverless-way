output "acr_login_server" {
  description = "The URL of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server         #azurerm_container_registry.acr.*.login_server
}

output "azurevm_devopsagent_privateip" {
  description = "Private IP address of Azure VM DevOps Agent"
  value       = azurerm_linux_virtual_machine.azure_vm_devopsagent.private_ip_address
}
