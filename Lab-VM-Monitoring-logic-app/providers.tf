terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
