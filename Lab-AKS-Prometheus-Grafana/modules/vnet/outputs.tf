output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_default_name" {
  value = azurerm_subnet.aks-default.name
}