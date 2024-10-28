resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_datasource_windows_performance_counter" "CPU_counter" {
  # jest możliwość wykorzystania pętli for each dla wielu obiektów tego samego typu lecz różnych wartości
  name                = "CPU_Counter"
  resource_group_name = data.azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.law.name
  object_name         = "CPU"
  instance_name       = "*"
  counter_name        = "CPU"
  interval_seconds    = 10
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "standard_message"
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "actiongroup"

  email_receiver {
    email_address           = "thisismail@domain.com"
    name                    = "mail_-EmailAction-"
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_metric_alert" "alert_high_cpu" {
  name                     = "high_cpu"
  resource_group_name      = data.azurerm_resource_group.rg.name
  scopes                   = [data.azurerm_resource_group.rg.id]
  target_resource_location = data.azurerm_resource_group.rg.location
  description              = "High CPU usage"
  target_resource_type     = "Microsoft.Compute/virtualMachines"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}


//        "\\System\\Processes",
//        "\\Process(_Total)\\Thread Count",
//        "\\Process(_Total)\\Handle Count",
//        "\\System\\System Up Time",
//        "\\System\\Context Switches/sec",
//        "\\System\\Processor Queue Length",
//        "\\Memory\\% Committed Bytes In Use",
//        "\\Memory\\Available Bytes",
//        "\\Memory\\Committed Bytes",
//        "\\Memory\\Cache Bytes",
//        "\\Memory\\Pool Paged Bytes",
//        "\\Memory\\Pool Nonpaged Bytes",
//        "\\Memory\\Pages/sec",
//        "\\Memory\\Page Faults/sec",
//        "\\Process(_Total)\\Working Set",
//        "\\Process(_Total)\\Working Set - Private",
//        "\\LogicalDisk(_Total)\\% Disk Time",
//        "\\LogicalDisk(_Total)\\% Disk Read Time",
//        "\\LogicalDisk(_Total)\\% Disk Write Time",
//        "\\LogicalDisk(_Total)\\% Idle Time",
//        "\\LogicalDisk(_Total)\\Disk Bytes/sec",
//        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
//        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
//        "\\LogicalDisk(_Total)\\Disk Transfers/sec",
//        "\\LogicalDisk(_Total)\\Disk Reads/sec",
//        "\\LogicalDisk(_Total)\\Disk Writes/sec",
//        "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
//        "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
//        "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
//        "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
//        "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
//        "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
//        "\\LogicalDisk(_Total)\\% Free Space",
//        "\\LogicalDisk(_Total)\\Free Megabytes",
//        "\\Network Interface(*)\\Bytes Total/sec",
//        "\\Network Interface(*)\\Bytes Sent/sec",
//        "\\Network Interface(*)\\Bytes Received/sec",
//        "\\Network Interface(*)\\Packets/sec",
//        "\\Network Interface(*)\\Packets Sent/sec",
//        "\\Network Interface(*)\\Packets Received/sec",
//        "\\Network Interface(*)\\Packets Outbound Errors",
//        "\\Network Interface(*)\\Packets Received Errors",
