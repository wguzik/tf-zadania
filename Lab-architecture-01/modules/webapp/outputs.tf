output "webapp_fqdn" {
  value = azurerm_linux_web_app.tfwebapp.default_hostname
}