# Użyj biblioteki/dodatku do terraforma, który pozwala wchodzić w interakcję z chmurą Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # pozyskaj domyślnego repozytorium
      version = "~>4.24.0" # jakie to ograniczenie wersji?
    }
  }
}

# Dodatkowa konfiguracja providera, np. można wskazać konto serwisowe którego powinien używać terraform to interakcji z chmurą lub domyślną subskrypcję
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Zmienna wejściowa pozwalająca na przekazanie nazwy środowiska
variable "environment" {
     type  = string
  default = "dev" # domyślna wartość pozwala ominąć przekazanie tej zmiennej w trakcie uruchamiania
}

# Zmienna wejściowa pozwalająca na przekazanie inicjałów właściciela zasobu
variable "owner" {
  type =  string
}

locals {
  # Tworzenie całych nazw uprzednio nie jest dobrą praktyką, późniejsze zarządzanie zasobami jest utrudnione
resourcegroup_name = "rg-${var.environment}-${var.owner}"
  storageaccount_name = "sa-${var.environment}-${var.owner}"
}

# Stwórz Resource Group
resource "azurerm_resource_group" "tfrg" {
  name     = local.resourcegroup_name
  locaton = "West Europe"
}

# Stwórz Storage Account
resource "azurerm_storage_account" "tfsa" {
  name                     = local.storageaccount_name
  resource_group_name      = azurerm_resource_group.tfrg.name # używa odniesienia do innego zasobu tworzonego w ramach tej konfiguracji
    location           = azurerm_resource_group.tfrg.location # używa odniesienia do innego zasobu tworzonego w ramach tej konfiguracji
account_tier                   = "Standard"
account_replication_type = "LRS"

  tags = {
  environment = "test"
  }
}

# Zwróć pełen URL do Storage Account od typu blob
output "storage_account_blob_url" {
  value = azurerm_storage_account.tfsa.primary_blob_endpoint
}