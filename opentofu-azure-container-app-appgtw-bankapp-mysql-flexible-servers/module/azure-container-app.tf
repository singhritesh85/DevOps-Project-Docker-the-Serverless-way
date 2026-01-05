resource "azurerm_resource_group" "aca_rg" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    Environment = var.env
  }
}

resource "azurerm_log_analytics_workspace" "aca_log_analytics_workspace" {
  name                = "${var.prefix}-log-analytics-workspace"
  location            = azurerm_resource_group.aca_rg.location
  resource_group_name = azurerm_resource_group.aca_rg.name

  tags = {
    Environment = var.env
  }
}

resource "azurerm_container_app_environment" "aca_environment" {
  name                       = "${var.prefix}-environment"
  location                   = azurerm_resource_group.aca_rg.location
  resource_group_name        = azurerm_resource_group.aca_rg.name
  infrastructure_subnet_id   = azurerm_subnet.azure_container_apps.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aca_log_analytics_workspace.id
  internal_load_balancer_enabled = true

  tags = {
    Environment = var.env
  }
}

resource "azurerm_container_app_environment_certificate" "ssl_certificate" {
  name                         = "${var.prefix}-certificate"
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  certificate_blob_base64      = filebase64("mykey.pfx")
  certificate_password         = var.certificate_password
}

data "azurerm_container_registry" "aca_container_registry" {
  name                = "devopsagentcontainer24registry"
  resource_group_name = "devopsagent-rg"
}

resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = azurerm_resource_group.aca_rg.name
  location            = azurerm_resource_group.aca_rg.location
  name                = "${var.prefix}-image-pull-identity"
}

resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = data.azurerm_container_registry.aca_container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
}

resource "azurerm_container_app" "aca_bankapp" {
  name                         = "${var.prefix}-bankapp"

  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = azurerm_resource_group.aca_rg.name
  revision_mode                = "Multiple"

#  secret {
#    name  = "acr-password"
#    value = var.PASSWORD_ACR
#  }
  
  identity {     ### To be used in case of User Assigned Identity
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_identity.id]
  }

  registry {
    server               = var.SERVER_ACR
#   username             = var.USERNAME_ACR
#   password_secret_name = "acr-password"
    identity             = azurerm_user_assigned_identity.acr_identity.id  ### To be used in case of User Assigned Identity
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080
    traffic_weight {
      percentage      = 100
      label           = "current"
      latest_revision = true
    }
  }

  template {
    container {
      name   = "${var.prefix}-bankapp"
      image  = "${var.SERVER_ACR}/${var.REPO_NAME}:${var.TAG_NUMBER}"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "JDBC_URL"
        value = "jdbc:mysql://${azurerm_mysql_flexible_server.azure_mysql.fqdn}:3306/bankappdb?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC"
      }
      env {
        name  = "JDBC_PASS" 
        value = azurerm_mysql_flexible_server.azure_mysql.administrator_password
      }
      env {
        name  = "JDBC_USER"
        value = azurerm_mysql_flexible_server.azure_mysql.administrator_login
      }      
      liveness_probe {
        failure_count_threshold = 3
        initial_delay           = 60
        interval_seconds        = 30
        path                    = "/login"
        port                    = 8080
        timeout                 = 1
        transport               = "HTTP"
      }
      startup_probe {
        failure_count_threshold = 3
        initial_delay           = 60
        interval_seconds        = 30
        path                    = "/login"
        port                    = 8080
        timeout                 = 1
        transport               = "HTTP"
      }
    }
    max_replicas = 3
    min_replicas = 1
    cooldown_period_in_seconds  = 300
    polling_interval_in_seconds = 30
    http_scale_rule {
      name = "${var.prefix}-http-scale-rule"
      concurrent_requests = 100   ### The concurrent request to trigger scaling.
    }
    custom_scale_rule {
      name = "${var.prefix}-cpu-utilization"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"  ### type can be "Utilization" or "AverageValue"
        value = "70"           ### Threshold 70% CPU usage 
      }
    }
    custom_scale_rule {
      name = "${var.prefix}-memory-utilization"
      custom_rule_type = "memory"
      metadata = {
        type  = "Utilization"  ### type can be "Utilization" or "AverageValue"
        value = "80"           ### Threshold 80% Memory usage
      }
    }
  }

  tags = {
    Environment = var.env
  }

  depends_on = [azurerm_mysql_flexible_server_configuration.secure_transport_off]

}

