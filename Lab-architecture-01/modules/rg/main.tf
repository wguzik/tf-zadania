resource "azurerm_resource_group" "tfrg" {
  name     = "rg-${var.environment}-${var.owner}"
  location = var.location
}
