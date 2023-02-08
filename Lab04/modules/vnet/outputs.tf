output "vnet_name" {
  value = azurerm_virtual_network.tfvnet.name
}

output "subnet_id" {
  value = azurerm_subnet.tfsub01.id
}
