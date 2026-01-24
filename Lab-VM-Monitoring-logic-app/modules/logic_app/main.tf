resource "azurerm_logic_app_workflow" "vm_manager" {
  name                = "logic-vm-manager-${var.postfix}"
  location            = var.location
  resource_group_name = var.rg_name
  enabled             = true

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Terraform Demo"
    purpose     = "VM Management"
  }
}

# Deploy the workflow definition from file
resource "azurerm_resource_group_template_deployment" "workflow_definition" {
  name                = "workflow-definition-${var.postfix}"
  resource_group_name = var.rg_name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema" = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"
    resources = [
      {
        type       = "Microsoft.Logic/workflows"
        apiVersion = "2019-05-01"
        name       = azurerm_logic_app_workflow.vm_manager.name
        location   = var.location
        identity = {
          type = "SystemAssigned"
        }
        properties = {
          definition = jsondecode(file("${path.module}/workflows/vm-manager.json")).definition
          state      = "Enabled"
        }
      }
    ]
  })

  depends_on = [
    azurerm_logic_app_workflow.vm_manager
  ]
}

# Role assignment: VM Contributor at subscription level
resource "azurerm_role_assignment" "vm_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_logic_app_workflow.vm_manager.identity[0].principal_id
}

# Monitor Action Group linked to Logic App
resource "azurerm_monitor_action_group" "vm_manager" {
  name                = "ag-vm-manager-${var.postfix}"
  resource_group_name = var.rg_name
  short_name          = "vm-mgr"
  enabled             = true

  logic_app_receiver {
    name                    = "trigger-vm-manager"
    resource_id             = azurerm_logic_app_workflow.vm_manager.id
    callback_url            = azurerm_logic_app_workflow.vm_manager.access_endpoint
    use_common_alert_schema = true
    identity_authorization_type = "SystemAssigned"
  }

  tags = {
    environment = "Terraform Demo"
    purpose     = "VM Management Alerts"
  }

  depends_on = [
    azurerm_resource_group_template_deployment.workflow_definition
  ]
}
