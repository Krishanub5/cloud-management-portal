data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "secrets" {
  name                        = "kv-cloudportal"
  resource_group_name         = azurerm_resource_group.portal.name
  location                    = azurerm_resource_group.portal.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}

resource "azurerm_key_vault_secret" "bb_token" {
  name         = "bitbucket-token"
  value        = "bb_example_token"
  key_vault_id = azurerm_key_vault.secrets.id
}

resource "azurerm_key_vault_secret" "teams_webhook" {
  name         = "teams-webhook-url"
  value        = "https://outlook.office.com/webhook/..."
  key_vault_id = azurerm_key_vault.secrets.id
}
