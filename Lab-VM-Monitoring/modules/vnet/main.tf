

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]

  //tags = {
  //  environment = data.azurerm_resource_group.rg.name.tags["environment"]
  //}
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-default-${var.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.240.0.0/16"]
}