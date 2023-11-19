resource "azurerm_lb" "tflb" {
  name                = "lb-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location

  sku = "Basic"

  frontend_ip_configuration {
    name      = "lb-fe-${var.environment}-${var.owner}"
    subnet_id = var.subnet_back_id
  }

}

resource "azurerm_lb_backend_address_pool" "tflbbackend" {
  loadbalancer_id = azurerm_lb.tflb.id
  name            = "vm-backend"
}

//resource "azurerm_network_interface_backend_address_pool_association" "vm1association" {
//  network_interface_id    = var.vm1_nic
//  ip_configuration_name   = "internal"
//  backend_address_pool_id = azurerm_lb_backend_address_pool.tflbbackend.id
//}
