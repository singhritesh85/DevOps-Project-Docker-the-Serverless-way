output "mysql_flexible_server_endpoint" {
  description = "The FQDN of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.azure_mysql.fqdn
}

output "mysql_flexible_server_database_name" {
  description = "The name of the MySQL Flexible Database"
  value       = azurerm_mysql_flexible_database.bankapp_db.name
}

output "container_app_bankapp_id" {
  description = "The ID of the BankApp Container App resource."
  value       = azurerm_container_app.aca_bankapp.id
}

output "azurerm_container_app_bankapp_latest_revision_fqdn" {
  description = "The FQDN of the latest revision of the BankApp Container App (includes revision ID)"
  value = azurerm_container_app.aca_bankapp.latest_revision_fqdn
}

output "azurerm_container_app_bankapp_url" {
  description = "The URL of the Azure Container App BankApp"
  value       = azurerm_container_app.aca_bankapp.ingress[0].fqdn
}

output "container_apps_environment_static_ip" {
  description = "The static IP address of the Container Apps Environment"
  value       = azurerm_container_app_environment.aca_environment.static_ip_address
}

output "application_gateway_frontend_ip" {
  description = "The public IP address of the Application Gateway's frontend."
  value       = azurerm_public_ip.public_ip_gateway_aca.ip_address
}
