module "vwan" {
  count  = local.create_vwan == true ? 1 : 0
  source = "../modules/vwan"
  vwan   = local.vwan_subscription.vwan
  providers = {
    azurerm = azurerm.sb_net_prod
  }
}

resource "random_string" "rid_hubs" {
  for_each    = { for hub in local.vwan_subscription.hubs : hub.name => hub }
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

module "hubs" {
  source                  = "../modules/hub"
  for_each                = { for hub in local.vwan_subscription.hubs : hub.name => hub }
  location                = local.config_file.location
  rid_hub                 = random_string.rid_hubs[each.value.name].result
  hub                     = each.value
  log_analytics_workspace = local.config_file.log_analytics_workspace
  vwan = {
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : data.terraform_remote_state.vwan[0].outputs.vwan.id
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : data.terraform_remote_state.vwan[0].outputs.vwan.rg_name
  }

  providers = {
    azurerm = azurerm.sb_net_prod
  }
}

data "azurerm_monitor_diagnostic_categories" "azmon_diag_categories" {
  resource_id = module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.id
}

resource "azurerm_monitor_diagnostic_setting" "fw_mdg" {
  provider                       = azurerm.sb_net_prod
  name                           = "diag-${module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.name}"
  target_resource_id             = module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.id
  storage_account_id             = module.netw_sa_net_prod[0].id
  log_analytics_workspace_id     = local.config_file.log_analytics_workspace.resource_id
  log_analytics_destination_type = "Dedicated"

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }

  dynamic "log" {
    for_each = local.fw_diag_settings_categories
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 90
      }
    }
  }
}
