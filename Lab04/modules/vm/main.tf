resource "azurerm_public_ip" "tfpip" {
  name                = "pip01-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "tfnic" {
  name                = "nic-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfpip.id
  }
}

resource "azurerm_linux_virtual_machine" "tfvm01" {
  name                = "vm01-${var.environment}-${var.owner}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location
  size                = "Standard_B1"
  admin_username      = "adminuser"
  admin_password      = "passwd"
  network_interface_ids = [
    azurerm_network_interface.tfnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}