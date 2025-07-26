resource "azurerm_application_insights" "backend" {
  name                = "appi-cloudportal"
  location            = azurerm_resource_group.portal.location
  resource_group_name = azurerm_resource_group.portal.name
  application_type    = "web"
}

resource "azurerm_monitor_diagnostic_setting" "app_insights" {
  name               = "diag-settings"
  target_resource_id = azurerm_linux_web_app.backend.id
  log_analytics_workspace_id = azurerm_monitor_workspace.datadog.id

  logs {
    category = "AppServiceConsoleLogs"
    enabled  = true
  }

  metrics {
    category = "AllMetrics"
    enabled  = true
  }
}
