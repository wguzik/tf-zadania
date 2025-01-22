terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.117.0"
    }
    ##Sekcja-namespace
    #kubernetes = {
    #  source  = "hashicorp/kubernetes"
    #  version = "2.35.1"
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