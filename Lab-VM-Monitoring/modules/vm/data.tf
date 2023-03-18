locals {
  vm_name = var.prefix
}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.rg_name_shared
}

//data "azurerm_monitor_data_collection_rule" "monitor_data_collection_rule" {
//  name                = var.monitor_data_collection_rule_name
//  resource_group_name = var.rg_name_shared
//}