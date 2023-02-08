data "azurerm_client_config" "current" {} # pozwala pobrać detale bieżącej sesji, m.in. tenant ID

resource "azurerm_resource_group" "tfrg" {
  name     = "rg-${var.environment}-${var.owner}"
  location = "West Europe"
}

resource "azurerm_postgresql_flexible_server" "tfpsql" {
    version = 11
  name                   = "psql-${var.environment}-${var.owner}"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  administrator_login    = "psqladmin"
  administrator_password = "paswd"
  backup_retention_days  = 7
  sku_name               = "B_Standard_B1ms"
    zone                   = "1"
}
