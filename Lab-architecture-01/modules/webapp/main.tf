resource "azurerm_service_plan" "tfsp" {
  name                = "sp-${var.environment}-${var.owner}-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  os_type             = "Linux"
  sku_name            = "P0v3"

  lifecycle {
    ignore_changes = [location]
  }
}

resource "azurerm_linux_web_app" "tfwebapp" {
  name                = "app-${var.environment}-${var.owner}-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  service_plan_id     = azurerm_service_plan.tfsp.id

  virtual_network_subnet_id = var.subnet_webfarm_id

  site_config {
    ip_restriction {
      action                    = "Allow"
      name                      = "appgw_subnet"
      virtual_network_subnet_id = var.subnet_appgw_id
      priority                  = 200
    }
  }

  app_settings = {
    backend_IP = var.lb_ip
  }

  lifecycle {
    ignore_changes = [location]
  }
}

## Krok #8
//resource "azurerm_private_endpoint" "tfwebappe" {
//  name                = "app-pe-${var.environment}-${var.owner}-${var.postfix}"
//  location            = data.azurerm_resource_group.tfrg.location
//  resource_group_name = data.azurerm_resource_group.tfrg.name
//  subnet_id           = var.subnet_pe_id
//
//  private_service_connection {
//    name                           = "app-pc-${var.environment}-${var.owner}-${var.postfix}"
//    private_connection_resource_id = azurerm_linux_web_app.tfwebapp.id
//    subresource_names              = ["sites"]
//    is_manual_connection           = false
//  }
//}
