output "aks_login_command" {
  value = "az aks get-credentials --name ${azurerm_kubernetes_cluster.aks.name} --resource-group ${data.azurerm_resource_group.rg.name}"
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}