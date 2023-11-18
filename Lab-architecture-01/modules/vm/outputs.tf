//output "public_ip" {
//  value = azurerm_public_ip.tfpip.ip_address
//}

output "vm_name" {
  value = azurerm_linux_virtual_machine.tfvm.name
}

output "vm_nic" {
  value = azurerm_network_interface.tfnic.id
}