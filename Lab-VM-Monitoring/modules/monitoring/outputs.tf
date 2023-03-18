output "law_name" {
  description = "Key Vault ID"
  value       = azurerm_log_analytics_workspace.law.name
}

//output "monitor_data_collection_rule_name" {
//  value = azurerm_monitor_data_collection_rule.datacollectionrule.name
//}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.workspace_id
}

output "law_key" { # this should go via KeyVault!
  value = azurerm_log_analytics_workspace.law.primary_shared_key
}