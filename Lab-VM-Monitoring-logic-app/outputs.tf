output "logic_app_id" {
  value       = module.logic_app.logic_app_id
  description = "The ID of the Logic App"
}

output "logic_app_name" {
  value       = module.logic_app.logic_app_name
  description = "The name of the Logic App"
}

output "logic_app_identity_principal_id" {
  value       = module.logic_app.logic_app_identity_principal_id
  description = "The Principal ID of the Logic App System Assigned Identity"
}
