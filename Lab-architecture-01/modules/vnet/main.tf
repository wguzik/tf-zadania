resource "azurerm_virtual_network" "tfvnet" {
  name                = "vnet-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "tfsub01-appgw" {
  name                                           = "sub01-appgw-${var.environment}-${var.owner}"
  resource_group_name                            = data.azurerm_resource_group.tfrg.name
  virtual_network_name                           = azurerm_virtual_network.tfvnet.name
  address_prefixes                               = ["10.0.0.0/24"]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.Web"]
}

resource "azurerm_subnet" "tfsub02-front" {
  name                                           = "sub02-front-${var.environment}-${var.owner}"
  resource_group_name                            = data.azurerm_resource_group.tfrg.name
  virtual_network_name                           = azurerm_virtual_network.tfvnet.name
  address_prefixes                               = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "tfsub03-back" {
  name                 = "sub03-back-${var.environment}-${var.owner}"
  resource_group_name  = data.azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "tfsub04-webfarm" {
  name                 = "sub04-webfarm-${var.environment}-${var.owner}"
  resource_group_name  = data.azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_network_security_group" "tfnsg01" {
  name                = "nsg01-${var.environment}-${var.owner}"
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

resource "azurerm_subnet_network_security_group_association" "nsg01assocation" {
  subnet_id                 = azurerm_subnet.tfsub01-appgw.id
  network_security_group_id = azurerm_network_security_group.tfnsg01.id
}

resource "azurerm_network_security_group" "tfnsg03" {
  name                = "nsg03-${var.environment}-${var.owner}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "nsg03-allin-${var.environment}"
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

resource "azurerm_subnet_network_security_group_association" "nsg03assocation" {
  subnet_id                 = azurerm_subnet.tfsub03-back.id
  network_security_group_id = azurerm_network_security_group.tfnsg03.id
}
