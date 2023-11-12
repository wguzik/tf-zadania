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
  vnet_name = module.naming.virtual_network.name
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.Sql"],
    "subnet2" : ["Microsoft.Sql"],
    "subnet3" : ["Microsoft.Sql"]
  }
  use_for_each = true
  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}

module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "7.4.0"
  prefix              = "wgkek"
  resource_group_name = azurerm_resource_group.example.name
  cluster_name        = module.naming.kubernetes_cluster.name
  vnet_subnet_id      = module.network.vnet_subnets[0]

  log_analytics_workspace_enabled = false

  rbac_aad = false

  sku_tier = "Free"

  node_pools = {
    worker1 = {
      name           = "pool"
      vnet_subnet_id = module.network.vnet_subnets[0]
      node_count     = 1
      vm_size        = "Standard_D2s_v3"
    }
  }
  
 depends_on = [azurerm_resource_group.example]
}