output "PostreSQL_URL" {
  value = azurerm_postgresql_flexible_server.tfpsql.fqdn
}