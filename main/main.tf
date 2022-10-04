module "vwan" {
  count  = local.create_vwan == true ? 1 : 0
  source = "../modules/vwan"
  vwan   = local.vwan_subscription.vwan
  providers = {
    azurerm = azurerm.vwan_hubs
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
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_id
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_rg_name
  }

  providers = {
    azurerm = azurerm.vwan_hubs
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
  provider = azurerm.vwan_hubs
  name     = "${local.vwan_subscription.netw_rg_name}-${random_string.vwan_hub_rids[local.netw_rg_key].result}"
  location = local.config_file.location
}


resource "azurerm_storage_account" "netw_sb_net_prod" {
  provider            = azurerm.vwan_hubs
  name                = "${local.vwan_subscription.netw_sa_acc_name}${random_string.vwan_hub_rids[local.sa_key].result}"
  resource_group_name = azurerm_resource_group.rg_vwan_hub_log_prod.name
  location            = azurerm_resource_group.rg_vwan_hub_log_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_sb_net_prod" {
  provider            = azurerm.vwan_hubs
  name                = "${local.vwan_subscription.netw_name}-${random_string.vwan_hub_rids[local.netw_key].result}"
  location            = azurerm_resource_group.rg_vwan_hub_log_prod.location
  resource_group_name = azurerm_resource_group.rg_vwan_hub_log_prod.name
}

resource "azurerm_monitor_diagnostic_setting" "fw_mdg" {
  provider                   = azurerm.vwan_hubs
  name                       = "diag-${module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.name}"
  target_resource_id         = module.hubs[local.vwan_subscription.hubs[0].name].hub.firewall.id
  storage_account_id         = azurerm_storage_account.netw_sb_net_prod.id
  log_analytics_workspace_id = local.config_file.log_analytics_workspace.resource_id

  log {
    category = "AZFWApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWDnsQuery"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWFatFlow"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWFqdnResolveFailure"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWIdpsSignature"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWNatRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWNatRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWNetworkRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AZFWThreatIntel"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }
}