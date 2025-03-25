data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_subnet" "aks_default" {
  name                 = var.subnet_default_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

//data "azurerm_subnet" "aks_app" {
//  name                 = var.subnet_app_name
//  virtual_network_name = var.vnet_name
//  resource_group_name  = data.azurerm_resource_group.rg.name
//}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.postfix}"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_D4_v5"
    vnet_subnet_id = data.azurerm_subnet.aks_default.id
  }

  identity {
    type = "SystemAssigned"
  }

  //tags = {
  //  environment = var.environment
  //  team        = var.team_name
  //}

  lifecycle {
    ignore_changes = [
      default_node_pool
    ]
  }
}

// resource "azurerm_kubernetes_cluster_node_pool" "appworkload" {
//   name                  = "appworkload"
//   node_count            = 1
//   enable_auto_scaling   = false
//   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
//   vm_size               = "Standard_D2_v2"
//   vnet_subnet_id        = data.azurerm_subnet.aks_app.id
// 
//   tags = {
//     environment = var.environment
//     team        = var.team_name
//   }
// }

