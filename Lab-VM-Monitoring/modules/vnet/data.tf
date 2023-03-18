data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {}