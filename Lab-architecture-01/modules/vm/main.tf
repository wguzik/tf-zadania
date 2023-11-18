resource "random_password" "password" {
  length           = 12
  min_upper        = 3
  min_special      = 1
  special          = true
  override_special = "!?#"
}

resource "azurerm_key_vault_secret" "tfvmsecret" {
  key_vault_id = var.kv_id
  name         = "pass-${var.environment}-${var.owner}-${var.postfix}"
  value        = random_password.password.result
}

//resource "azurerm_public_ip" "tfpip" {
//  name                = "pip01-${var.environment}-${var.owner}-${var.postfix}"
//  resource_group_name = data.azurerm_resource_group.tfrg.name
//  location            = data.azurerm_resource_group.tfrg.location
//  allocation_method   = "Dynamic"
//}

resource "azurerm_network_interface" "tfnic" {
  name                = "nic-${var.environment}-${var.owner}-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.tfrg.name
  location            = data.azurerm_resource_group.tfrg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    // public_ip_address_id          = azurerm_public_ip.tfpip.id
  }
}

resource "azurerm_linux_virtual_machine" "tfvm" {
  name                            = "vm01-${var.environment}-${var.owner}-${var.postfix}"
  resource_group_name             = data.azurerm_resource_group.tfrg.name
  location                        = data.azurerm_resource_group.tfrg.location
  size                            = "Standard_B2s"
  admin_username                  = "adminuser"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  custom_data = base64encode(file("modules/vm/scripts/init.sh"))

  network_interface_ids = [
    azurerm_network_interface.tfnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202209200"
  }
}