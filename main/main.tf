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

resource "random_string" "vwan_hub_rids" {
  for_each    = toset(local.vwan_hub_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_resource_group" "rg_vwan_hub_log_prod" {
  provider = azurerm.sb_net_prod
  name     = "${local.vwan_subscription.netw_rg_name}-${random_string.vwan_hub_rids[local.netw_rg_key].result}"
  location = local.config_file.location
}


resource "azurerm_storage_account" "netw_sb_net_prod" {
  provider            = azurerm.sb_net_prod
  name                = "${local.vwan_subscription.netw_sa_acc_name}${random_string.vwan_hub_rids[local.sa_key].result}"
  resource_group_name = azurerm_resource_group.rg_vwan_hub_log_prod.name
  location            = azurerm_resource_group.rg_vwan_hub_log_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_sb_net_prod" {
  provider            = azurerm.sb_net_prod
  name                = "${local.vwan_subscription.netw_name}-${random_string.vwan_hub_rids[local.netw_key].result}"
  location            = azurerm_resource_group.rg_vwan_hub_log_prod.location
  resource_group_name = azurerm_resource_group.rg_vwan_hub_log_prod.name
}

data "azurerm_monitor_diagnostic_categories" "azmon_diag_categories" {
  resource_id = module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.id
}

resource "azurerm_monitor_diagnostic_setting" "fw_mdg" {
  provider                       = azurerm.sb_net_prod
  name                           = "diag-${module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.name}"
  target_resource_id             = module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.id
  storage_account_id             = azurerm_storage_account.netw_sb_net_prod.id
  log_analytics_workspace_id     = local.config_file.log_analytics_workspace.resource_id
  log_analytics_destination_type = "AzureDiagnostics"

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.azmon_diag_categories.log_category_types
    content {
      category = log.value
      enabled  = true
      retention_policy {
        days    = 90
        enabled = true
      }
    }
  }
}
