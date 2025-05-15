terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.24"
    }
    ##Sekcja-namespace
    #kubernetes = {
    #  source  = "hashicorp/kubernetes"
    #  version = "2.36.0"
    #}
    ##Sekcja-metryki
    #helm = {
    #  source  = "hashicorp/helm"
    #  version = "2.17.0"
    #}
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

#Sekcja-namespace
provider "kubernetes" {
  config_path = "~/.kube/config"
}

##Sekcja-metryki
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

#resource "helm_release" "elastic_repo" {
#  name = "elastic"
#  repository = "https://helm.elastic.co"
#  chart = "repo"
#}