provider "azurerm" {
  features {}
}

variable "prefix" {
  type    = string
  default = "wglabdev" # użyj własnego prefixu, sugeruję inicjały i np. 'lab'
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["${var.prefix}"]
}

resource "azurerm_resource_group" "example" {
  name     = module.naming.resource_group.name
  location = "West Europe"
}

module "network" {
  vnet_name           = module.naming.virtual_network.name
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_spaces      = ["10.52.0.0/16"]
  subnet_prefixes     = ["10.52.0.0/24","10.52.1.0/24"]
  subnet_names        = ["subnet1", "subnet2"]

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.Sql"]
  }
  use_for_each = true
  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group.example]
}

locals {
  nodes = {
    for i in range(2) : "worker${i}" => {
      name           = "worker${i}"
      vm_size        = "Standard_D2s_v3"
      node_count     = 1
      vnet_subnet_id = module.network.vnet_subnets[0]
    }
  }
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "7.4.0"

  prefix                        = var.prefix
  resource_group_name           = azurerm_resource_group.example.name
  os_disk_size_gb               = 60
  public_network_access_enabled = false
  sku_tier                      = "Free"
  rbac_aad                      = false
  vnet_subnet_id                = module.network.vnet_subnets[0]
  node_pools                    = local.nodes

  log_analytics_workspace_enabled = false

  depends_on = [azurerm_resource_group.example,
    module.network
  ]
}