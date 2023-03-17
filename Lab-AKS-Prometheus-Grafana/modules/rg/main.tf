resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.postfix}"
  location = var.location

  tags = {
    environment = var.environment
    team        = var.project
  }
}