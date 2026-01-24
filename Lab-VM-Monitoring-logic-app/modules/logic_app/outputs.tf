output "logic_app_id" {
  value       = azurerm_logic_app_workflow.vm_manager.id
  description = "The ID of the Logic App"
}

output "logic_app_name" {
  value       = azurerm_logic_app_workflow.vm_manager.name
  description = "The name of the Logic App"
}

output "logic_app_identity_principal_id" {
  value       = azurerm_logic_app_workflow.vm_manager.identity[0].principal_id
  description = "The Principal ID of the Logic App System Assigned Identity"
}

output "logic_app_identity_tenant_id" {
  value       = azurerm_logic_app_workflow.vm_manager.identity[0].tenant_id
  description = "The Tenant ID of the Logic App System Assigned Identity"
}
