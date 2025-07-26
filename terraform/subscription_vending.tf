module "sub_vending" {
  source  = "Azure/avm-ptn-subscription/azurerm"
  version = "0.4.2"

  subscription_alias_name   = var.subscription_display_name
  subscription_display_name = var.subscription_display_name
  workload_environments     = [var.environment]
  management_group_id       = var.management_group_id

  tags = {
    environment  = var.environment
    costcenter   = var.cost_center
    purpose      = var.purpose
    requested_by = var.requested_by
  }
}
