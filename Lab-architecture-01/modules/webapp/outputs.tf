output "webapp_url" {
  value = azurerm_linux_web_app.tfwebapp.default_hostname
}
