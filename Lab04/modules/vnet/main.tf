resource "azurerm_network_security_group" "tfnsg01" {
  name                = "nsg-${var.environment}-${var.owner}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "nsg01-allin-${var.environment}"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "tfvnet" {
  name                = "vnet-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment =  "${var.environment}"
  }
}

resource "azurerm_subnet" "tfsub01" {
  name                 = "sub01-${var.environment}-${var.owner}"
  resource_group_name  = data.azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.tfsub01.id
  network_security_group_id = azurerm_network_security_group.tfnsg01.id
}