terraform {
  #backend "azurerm" {
  #  resource_group_name  = "<remote_backend_rg>"
  #  storage_account_name = "<remote_backend_storage_account>"
  #  container_name       = "dev" #dev one
  #  key                  = "terraform.tfstate"
  #}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.88.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}



provider "azurerm" {
  features {}
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}