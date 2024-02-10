#terraform {
#  required_providers {
#    azurerm = {
#      source  = "hashicorp/azurerm"
#      version = "~>3.88.0"
#    }
#    kubernetes = {
#      source  = "hashicorp/kubernetes"
#      version = "2.25.2"
#    }
#  }
#}
#
#provider "azurerm" {
#  features {
#
#  }
#
#}
#
#provider "kubernetes" {
#  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
#
#  username = data.azurerm_kubernetes_cluster.aks.kube_config.0.username
#  password = data.azurerm_kubernetes_cluster.aks.kube_config.0.password
#
#  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
#  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#}