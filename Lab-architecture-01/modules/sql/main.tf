resource "random_password" "password" {
  length           = 12
  min_upper        = 3
  min_special      = 1
  special          = true
  override_special = "!?#"
}

resource "azurerm_key_vault_secret" "tfsqsecret" {
  key_vault_id = var.kv_id
  name         = "pass-sql${var.environment}${var.owner}"
  value        = random_password.password.result
}

resource "azurerm_mssql_server" "tfsql" {
  name                         = "sql${var.environment}${var.owner}"
  resource_group_name          = data.azurerm_resource_group.tfrg.name
  location                     = data.azurerm_resource_group.tfrg.location
  version                      = "12.0"
  administrator_login          = "notregularuser"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

  public_network_access_enabled = false

  tags = {
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = [location]
  }
}

resource "azurerm_mssql_database" "tfdb" {
  name           = "sqldb${var.environment}${var.owner}"
  server_id      = azurerm_mssql_server.tfsql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_private_endpoint" "tfsqlpe" {
  name                = "sql-pe-${var.environment}-${var.owner}-${var.postfix}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = data.azurerm_resource_group.tfrg.name
  subnet_id           = var.subnet_back_id

  private_service_connection {
    name                           = "sql-pc-${var.environment}-${var.owner}-${var.postfix}"
    private_connection_resource_id = azurerm_mssql_server.tfsql.id
    subresource_names              = ["SqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    private_dns_zone_ids = [var.dns_id]
    name                 = var.dns_name

  }

  lifecycle {
    ignore_changes = [location]
  }
}
