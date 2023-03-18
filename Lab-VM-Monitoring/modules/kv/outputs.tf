output "kv_url" {
  value = azurerm_key_vault.kv.vault_uri
}

output "kv_name" {
  value = azurerm_key_vault.kv.name
}