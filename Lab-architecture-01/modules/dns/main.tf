resource "azurerm_private_dns_zone" "tfdnswebapp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.tfrg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnslinkwebapp" {
  name                  = "dns-webapp-link-${var.environment}-${var.owner}"
  resource_group_name   = data.azurerm_resource_group.tfrg.name
  private_dns_zone_name = azurerm_private_dns_zone.tfdnswebapp.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone" "tfdnssql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.tfrg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnslinksql" {
  name                  = "dns-sql-link-${var.environment}-${var.owner}"
  resource_group_name   = data.azurerm_resource_group.tfrg.name
  private_dns_zone_name = azurerm_private_dns_zone.tfdnssql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone" "tfdnskv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.tfrg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnslinkkv" {
  name                  = "kv-sql-link-${var.environment}-${var.owner}"
  resource_group_name   = data.azurerm_resource_group.tfrg.name
  private_dns_zone_name = azurerm_private_dns_zone.tfdnskv.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}