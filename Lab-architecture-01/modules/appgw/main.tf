resource "azurerm_public_ip" "tfappgwpip" {
  name                = "appgw-pip-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    ignore_changes = [location]
  }
}

# Application Gateway
resource "azurerm_application_gateway" "tfappgw" {
  name                = "appgw-${var.environment}-${var.owner}"
  location            = data.azurerm_resource_group.tfrg.location
  resource_group_name = data.azurerm_resource_group.tfrg.name

  enable_http2 = true

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = var.subnet_appgw_id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.tfappgwpip.id
  }

  backend_address_pool {
    name  = "AppService"
    fqdns = ["${var.webapp_fqdn}"]
  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  probe {
    name     = "probe"
    protocol = "Http"
    path     = "/"
    //host                = "${var.webapp_fqdn}"
    interval                                  = "30"
    timeout                                   = "30"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {
    name                                = "http"
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 1
    probe_name                          = "probe"
    pick_host_name_from_backend_address = true
  }

  request_routing_rule {
    priority                   = 1
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "AppService"
    backend_http_settings_name = "http"

  }

  lifecycle {
    ignore_changes = [location]
  }
}