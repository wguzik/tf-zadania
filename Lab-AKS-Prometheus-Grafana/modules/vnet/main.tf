data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]

  //tags = {
  //  environment = data.azurerm_resource_group.rg.name.tags["environment"]
  //}
}

resource "azurerm_subnet" "aks-default" {
  name                 = "snet-default-${var.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "aks-app" {
  name                 = "snet-app-${var.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.1.0.0/16"]
}