resource "azurerm_public_ip" "pip" {
  name                = "pip01-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "random_password" "vm_password" {
  length           = 16
  min_upper        = 2
  special          = true
  min_special      = 1
  override_special = "!$#"
}

resource "azurerm_key_vault_secret" "vm_user" {
  name         = "${local.vm_name}-user"
  value        = "superadmin"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "${local.vm_name}-password"
  value        = random_password.vm_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = local.vm_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_D2_v3"
  admin_username      = azurerm_key_vault_secret.vm_user.value
  admin_password      = azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "lawagent" {
  name                       = "AzureMonitorWindowsAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  settings           = <<SETTINGS
    {
      "workspaceId": "${var.law_id}"
    }
   SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
   {
      "workspaceKey": "${var.law_key}"
   }
    PROTECTED_SETTINGS
}

//resource "azurerm_monitor_data_collection_rule_association" "rule_associations" {
//  name                    = "vm-rule-association"
//  target_resource_id      = azurerm_windows_virtual_machine.vm.id
//  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.monitor_data_collection_rule.id
//  description             = "Associate to monitoring"
//}