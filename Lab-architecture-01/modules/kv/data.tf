data "azurerm_resource_group" "tfrg" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {}