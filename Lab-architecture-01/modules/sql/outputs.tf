output "db_fqdn" {
  value = azurerm_mssql_server.tfsql.fully_qualified_domain_name
}