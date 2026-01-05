################################################### Azure Application Gateway For Azure Container App ########################################################

resource "azurerm_public_ip" "public_ip_gateway_aca" {
  name                = "vmss-public-ip-aca"
  resource_group_name = azurerm_resource_group.aca_rg.name
  location            = azurerm_resource_group.aca_rg.location
  sku                 = "Standard"   ### You can select between Basic and Standard.
  allocation_method   = "Static"     ### You can select between Static and Dynamic.
}

resource "azurerm_application_gateway" "application_gateway_aca" {
  name                = "${var.prefix}-application-gateway-aca"
  resource_group_name = azurerm_resource_group.aca_rg.name
  location            = azurerm_resource_group.aca_rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "aca-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgtw_subnet.id
  }

  frontend_port {
    name = "${var.prefix}-gateway-subnet-feport-aca"
    port = 80
  }

  frontend_port {
    name = "${var.prefix}-gateway-subnet-feporthttps-aca"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-gateway-subnet-feip-aca"
    public_ip_address_id = azurerm_public_ip.public_ip_gateway_aca.id
    private_link_configuration_name = "${var.prefix}-private-link-config"
  }

  private_link_configuration {
    name = "${var.prefix}-private-link-config"
    ip_configuration {
      name                          = "${var.prefix}-ip-config"
      subnet_id                     = azurerm_subnet.appgtw_subnet.id
      private_ip_address_allocation = "Dynamic"
      primary                       = true
    }
  }

  backend_address_pool {
    name  = "${var.prefix}-gateway-subnet-beap-aca"
#    ip_addresses = [azurerm_container_app_environment.aca_environment.static_ip_address]
    fqdns = [azurerm_container_app.aca_bankapp.ingress[0].fqdn]     ###[azurerm_container_app_environment.aca_environment.default_domain] 
  }

  backend_http_settings {
    name                  = "${var.prefix}-gateway-subnet-be-htst-aca"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    probe_name            = "${var.prefix}-gateway-subnet-be-probe-app1-aca"
#    host_name             = azurerm_container_app.aca_bankapp.latest_revision_fqdn    ###azurerm_container_app_environment.aca_environment.default_domain
    pick_host_name_from_backend_address = true
  }

  probe {
    name                = "${var.prefix}-gateway-subnet-be-probe-app1-aca"
#    host                = "bankapp.singhritesh85.com"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Https"
    port                = 443
    path                = "/login"
#    host                = azurerm_container_app.aca_bankapp.latest_revision_fqdn
    pick_host_name_from_backend_http_settings = true
  }

  # HTTPS Listener - Port 80
  http_listener {
    name                           = "${var.prefix}-gateway-subnet-httplstn-aca"
    frontend_ip_configuration_name = "${var.prefix}-gateway-subnet-feip-aca"
    frontend_port_name             = "${var.prefix}-gateway-subnet-feport-aca"
    protocol                       = "Http"
  }

  # HTTP Routing Rule - Port 80
  request_routing_rule {
    name                       = "${var.prefix}-gateway-subnet-rqrt-aca"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "${var.prefix}-gateway-subnet-httplstn-aca"
    backend_address_pool_name  = "${var.prefix}-gateway-subnet-beap-aca"  ###  It should not be used when redirection of HTTP to HTTPS is configured.
    backend_http_settings_name = "${var.prefix}-gateway-subnet-be-htst-aca"   ###  It should not be used when redirection of HTTP to HTTPS is configured.
#    redirect_configuration_name = "${var.prefix}-gateway-subnet-rdrcfg-aca"
  }

  # Redirect Config for HTTP to HTTPS Redirect
#  redirect_configuration {
#    name = "${var.prefix}-gateway-subnet-rdrcfg-aca"
#    redirect_type = "Permanent"
#    target_listener_name = "${var.prefix}-lstn-https-aca"    ### "${var.prefix}-gateway-subnet-httplstn"
#    include_path = true
#    include_query_string = true
#  }

  # SSL Certificate Block
  ssl_certificate {
    name = "${var.prefix}-certificate"
    password = var.certificate_password
    data = filebase64("mykey.pfx")
  }

  # HTTPS Listener - Port 443
  http_listener {
    name                           = "${var.prefix}-lstn-https-aca"
    frontend_ip_configuration_name = "${var.prefix}-gateway-subnet-feip-aca"
    frontend_port_name             = "${var.prefix}-gateway-subnet-feporthttps-aca"
    protocol                       = "Https"
    ssl_certificate_name           = "${var.prefix}-certificate"
  }

  # HTTPS Routing Rule - Port 443
  request_routing_rule {
    name                       = "${var.prefix}-rqrt-https-aca"
    priority                   = 101
    rule_type                  = "Basic"
    http_listener_name         = "${var.prefix}-lstn-https-aca"
    backend_address_pool_name  = "${var.prefix}-gateway-subnet-beap-aca"
    backend_http_settings_name = "${var.prefix}-gateway-subnet-be-htst-aca"
  }
}
