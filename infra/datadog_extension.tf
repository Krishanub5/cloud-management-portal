resource "azurerm_monitor_workspace" "datadog" {
  name                = "dd-monitor-workspace"
  location            = azurerm_resource_group.portal.location
  resource_group_name = azurerm_resource_group.portal.name
}

resource "azurerm_monitor_data_collection_rule" "dd_rule" {
  name                = "dd-extension-dcr"
  location            = azurerm_resource_group.portal.location
  resource_group_name = azurerm_resource_group.portal.name
  kind                = "Linux"
  data_sources {
    performance_counters {
      name = "perf-counters"
      streams = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = ["\Processor(_Total)\% Processor Time"]
    }
  }
  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.datadog.id
      name               = "dd-monitor-destination"
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "dd_association" {
  name                    = "dd-extension-association"
  target_resource_id      = azurerm_linux_web_app.backend.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dd_rule.id
}
