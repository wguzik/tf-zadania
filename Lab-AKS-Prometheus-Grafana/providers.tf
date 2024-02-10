terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.88.0"
    }
    ##Sekcja-namespace
    #kubernetes = {
    #  source  = "hashicorp/kubernetes"
    #  version = "2.25.2"
    #}
    ##Sekcja-monitoring
    #helm = {
    #  source  = "hashicorp/helm"
    #  version = "2.12.1"
    #}
  }
}

provider "azurerm" {
  features {}
}

##Sekcja-namespace
#provider "kubernetes" {
#  config_path = "~/.kube/config"
#}

##Sekcja-monitoring
#provider "helm" {
#  kubernetes {
#    config_path = "~/.kube/config"
#  }
#}