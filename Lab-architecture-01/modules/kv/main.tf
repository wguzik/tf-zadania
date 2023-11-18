resource "random_password" "password" {
  length           = 12
  min_upper        = 1
  min_special      = 1
  special          = true
  override_special = "!?#$%&()-_=+[]{}<>:"
}

resource "azurerm_key_vault" "tfkv" {
  name                = "kv-${var.environment}-${var.owner}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = data.azurerm_resource_group.tfrg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List",
    ]
  }
  tags = {
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = [location]
  }
}

resource "azurerm_private_endpoint" "tfkve" {
  name                = "kv-pe-${var.environment}-${var.owner}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = data.azurerm_resource_group.tfrg.name
  subnet_id           = var.subnet_back_id

  private_service_connection {
    name                           = "kv-pc-${var.environment}-${var.owner}"
    private_connection_resource_id = azurerm_key_vault.tfkv.id
    subresource_names              = ["vault"]
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