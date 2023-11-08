terraform {
  backend "azurerm" {
    resource_group_name  = "statewsbwg-dev"
    storage_account_name = "statewsbwgdev26758"
    container_name       = "dev" #dev one
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }
  }
}

provider "azurerm" {
  features {}
}
