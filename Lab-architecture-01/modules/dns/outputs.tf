output "dns_webapp_id" {
  value = azurerm_private_dns_zone.tfdnswebapp.id
}

output "dns_webapp_name" {
  value = azurerm_private_dns_zone.tfdnswebapp.name
}

output "dns_sql_id" {
  value = azurerm_private_dns_zone.tfdnssql.id
}

output "dns_sql_name" {
  value = azurerm_private_dns_zone.tfdnssql.name
}

output "dns_kv_id" {
  value = azurerm_private_dns_zone.tfdnskv.id
}

output "dns_kv_name" {
  value = azurerm_private_dns_zone.tfdnskv.name
}