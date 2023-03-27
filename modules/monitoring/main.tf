resource "azurerm_network_watcher_flow_log" "netw_flow_logs" {
  for_each                  = var.nsg_keys
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.nsgs[each.key].resource_group_name
  name                      = "flow-${var.nsgs[each.key].name}"
  network_security_group_id = var.nsgs[each.key].id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace.id
    workspace_region      = var.log_analytics_workspace.location
    workspace_resource_id = var.log_analytics_workspace.resource_id
    interval_in_minutes   = 10
  }
}


resource "azurerm_monitor_diagnostic_setting" "mdg" {
  for_each                   = var.nsg_keys
  name                       = "diag-${var.nsgs[each.key].name}"
  target_resource_id         = var.nsgs[each.key].id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace.resource_id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  # metric {
  #   category = "AllMetrics"
  #   enabled  = false

  #   retention_policy {
  #     days    = 0
  #     enabled = false
  #   }
  # }
}


resource "azurerm_monitor_diagnostic_setting" "spoke_mdg" {
  name                       = "diag-${var.spoke.vnet.name}"
  target_resource_id         = var.spoke.vnet.id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace.resource_id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
