terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.86.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {} # pozwala pobrać detale bieżącej sesji, m.in. tenant ID

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type = string
}

resource "azurerm_resource_group" "tfrg" {
  name     = "rg-${var.environment}-${var.owner}"
  location = "West Europe"
}

resource "random_password" "password" {
  length           = 12
  min_upper        = 1
  min_special      = 1
  special          = true
  override_special = "!?#$%&()-_=+[]{}<>:"
}

resource "azurerm_key_vault" "tfkv" {
  name                = "kv-${var.environment}-${var.owner}"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List",
    ]
  }
}

resource "azurerm_key_vault_secret" "tfsecret" {
  key_vault_id = azurerm_key_vault.tfkv.id
  name = "tf-secret"
  value = random_password.password.result
}

output "keyvault_url" {
  value = azurerm_key_vault.tfkv.vault_uri
}