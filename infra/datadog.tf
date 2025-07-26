resource "azurerm_app_service_virtual_network_swift_connection" "backend_vnet" {
  app_service_id = azurerm_linux_web_app.backend.id
  subnet_id      = "<optional-subnet-id>"
}

resource "azurerm_app_service" "datadog_monitoring_extension" {
  name                = "dd-monitoring"
  location            = azurerm_resource_group.portal.location
  resource_group_name = azurerm_resource_group.portal.name
  app_service_plan_id = azurerm_service_plan.backend.id

  site_config {
    linux_fx_version = "DOCKER|datadog/agent:latest"
  }

  app_settings = {
    DD_API_KEY   = "your-datadog-api-key"
    DD_SITE      = "datadoghq.com"
    DD_LOGS_ENABLED = "true"
    DD_APM_ENABLED  = "true"
    DD_PROCESS_AGENT_ENABLED = "true"
  }
}
