output "vnet_name" {
  value = azurerm_virtual_network.tfvnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.tfvnet.id
}


output "subnet_id_appgw" {
  value = azurerm_subnet.tfsub01-appgw.id
}

output "subnet_id_front" {
  value = azurerm_subnet.tfsub02-front.id
}

output "subnet_id_back" {
  value = azurerm_subnet.tfsub03-back.id
}

output "subnet_id_webfarm" {
  value = azurerm_subnet.tfsub04-webfarm.id
}
