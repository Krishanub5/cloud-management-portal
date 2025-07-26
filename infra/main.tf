provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "portal" {
  name     = "rg-cloud-portal"
  location = "southeastasia"
}

resource "azurerm_static_site" "frontend" {
  name                = "cloud-mgmt-portal-frontend"
  resource_group_name = azurerm_resource_group.portal.name
  location            = azurerm_resource_group.portal.location
  sku_tier            = "Standard"
  sku_size            = "Standard"
}

resource "azurerm_service_plan" "backend" {
  name                = "asp-cloud-portal"
  resource_group_name = azurerm_resource_group.portal.name
  location            = azurerm_resource_group.portal.location
  os_type             = "Linux"
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "backend" {
  name                = "cloud-mgmt-portal-api"
  resource_group_name = azurerm_resource_group.portal.name
  location            = azurerm_resource_group.portal.location
  service_plan_id     = azurerm_service_plan.backend.id

  site_config {
    app_command_line = "
    linux_fx_version = "DOCKER|youracr.azurecr.io/cloud-mgmt-api:latest"
  }

  app_settings = {
    "TRIGGER_PROVISIONING" = "true"
    "BITBUCKET_TOKEN"      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.bb_token.id})"
    "BITBUCKET_WORKSPACE"  = "yourteam"
    "BITBUCKET_REPO"       = "cloud-mgmt-portal"
    "TEAMS_WEBHOOK_URL"    = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.teams_webhook.id})"
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_virtual_network" "vnet_vending" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    environment = var.env
    project     = "cloud-mgmt-portal"
  }
}


locals {
  vnet_definitions = csvdecode(file("${path.module}/data/vnets.csv"))
}

resource "azurerm_virtual_network" "vnet_vending" {
  for_each            = { for v in local.vnet_definitions : v.name => v }
  name                = each.value.name
  address_space       = [each.value.address_space]
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tags = {
    environment = each.value.env
    project     = "cloud-mgmt-portal"
  }
}
