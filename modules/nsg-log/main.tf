resource "azurerm_network_watcher_flow_log" "netw_flow_logs" {
  for_each             = { for nsg in var.nsgs : nsg.name => nsg }
  network_watcher_name = var.network_watcher_name
  resource_group_name  = each.value.resource_group_name
  name                 = "flow-${each.key}"

  network_security_group_id = each.value.id
  storage_account_id        = var.storage_account_id
  enabled                   = true

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
  for_each                   = { for nsg in var.nsgs : nsg.name => nsg }
  name                       = "diag-${each.key}"
  target_resource_id         = each.value.id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace.resource_id

  log {
    enabled = true

    retention_policy {
      enabled = false
    }
  }
}
