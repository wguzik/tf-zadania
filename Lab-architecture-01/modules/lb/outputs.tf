output "lb_ip" {
  value = azurerm_lb.tflb.private_ip_address
}