# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.resource_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.law_sku
  retention_in_days   = var.retention_days
}

#  Azure Monitor Agent on VMSS
resource "azurerm_virtual_machine_scale_set_extension" "ama" {
  name                         = var.ama_name
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = var.ama_publisher
  type                         = var.ama_type
  type_handler_version         = var.ama_version
  auto_upgrade_minor_version   = var.ama_auto_upgrade
}

# Data Collection Rule (Perf + Syslog) -> LAW
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "${var.resource_prefix}-dcr"
  location            = var.location
  resource_group_name = var.resource_group_name

  destinations {
    log_analytics {
      name                  = "toLaw"
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-Syslog"]
    destinations = ["toLaw"]
  }

  data_sources {
    performance_counter {
      name                          = "perf-basic"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\Memory\\Available MBytes",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }

    syslog {
      name          = "syslog-basic"
      streams       = ["Microsoft-Syslog"]
      facility_names = ["auth","authpriv","cron","daemon","kern","syslog","user"]
      log_levels     = ["Warning","Error","Critical","Alert","Emergency"]
    }
  }
}

#  Associate DCR with VMSS
resource "azurerm_monitor_data_collection_rule_association" "dcr_vmss" {
  name                    = "${var.resource_prefix}-dcrassoc"
  target_resource_id      = var.vmss_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
}



#  Action Group (email) + CPU alert on VMSS
resource "azurerm_monitor_action_group" "ag" {
  name                = "${var.resource_prefix}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "mon-ag"

  email_receiver {
    name                    = "email"
    email_address           = var.alert_email   
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                 = "${var.resource_prefix}-cpu-high"
  resource_group_name  = var.resource_group_name
  scopes               = [var.vmss_id]
  target_resource_type = "Microsoft.Compute/virtualMachineScaleSets"
  description          = "CPU > ${var.cpu_threshold}% for ${var.cpu_window}"
  severity             = 3
  frequency            = "PT1M"
  window_size          = var.cpu_window

  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.metric_aggregation
    operator         = var.metric_operator
    threshold        = var.cpu_threshold
  }

  action { action_group_id = azurerm_monitor_action_group.ag.id }
}