resource "random_string" "sa_netw_rids" {
  for_each    = toset(local.sb_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "random_string" "netw_rids" {
  for_each    = toset(local.sb_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_storage_account" "netw_sa_pfm_prod" {
  provider            = azurerm.sb_pfm_prod_01
  name                = "${local.subscriptions_map.sb_pfm_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_pfm_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_prod.name
  location            = azurerm_resource_group.rg_nsg_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_pfm_prod" {
  provider            = azurerm.sb_pfm_prod_01
  name                = "${local.subscriptions_map.sb_pfm_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_prod].result}"
  location            = azurerm_resource_group.rg_nsg_prod.location
  resource_group_name = azurerm_resource_group.rg_nsg_prod.name
}


module "nsg_log_pfm_prod" {
  for_each                = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_pfm_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_pfm_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_prod_01
  }
}



resource "azurerm_storage_account" "netw_sa_pfm_stg" {
  provider            = azurerm.sb_pfm_stg_01
  name                = "${local.subscriptions_map.sb_pfm_stg.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_pfm_stg].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_stg.name
  location            = azurerm_resource_group.rg_nsg_stg.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_pfm_stg" {
  provider            = azurerm.sb_pfm_stg_01
  name                = "${local.subscriptions_map.sb_pfm_stg.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_stg].result}"
  location            = azurerm_resource_group.rg_nsg_stg.location
  resource_group_name = azurerm_resource_group.rg_nsg_stg.name
}

module "nsg_log_pfm_stg" {
  for_each                = { for spoke in local.spokes.sb_pfm_stg : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_stg.name
  storage_account_id      = azurerm_storage_account.netw_sa_pfm_stg.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_pfm_stg[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_stg[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_stg_01
  }
}

resource "azurerm_storage_account" "netw_sa_pfm_qa" {
  provider            = azurerm.sb_pfm_qa_01
  name                = "${local.subscriptions_map.sb_pfm_qa.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_pfm_qa].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_qa.name
  location            = azurerm_resource_group.rg_nsg_qa.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_pfm_qa" {
  provider            = azurerm.sb_pfm_qa_01
  name                = "${local.subscriptions_map.sb_pfm_qa.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_qa].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_qa.name
  location            = azurerm_resource_group.rg_nsg_qa.location
}


module "nsg_log_pfm_qa" {
  for_each                = { for spoke in local.spokes.sb_pfm_qa : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_qa.name
  storage_account_id      = azurerm_storage_account.netw_sa_pfm_qa.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_pfm_qa[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_qa[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_qa_01
  }
}



resource "azurerm_storage_account" "netw_sa_pfm_dev" {
  provider            = azurerm.sb_pfm_dev_01
  name                = "${local.subscriptions_map.sb_pfm_dev.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_pfm_dev].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dev.name
  location            = azurerm_resource_group.rg_nsg_dev.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_pfm_dev" {
  provider            = azurerm.sb_pfm_dev_01
  name                = "${local.subscriptions_map.sb_pfm_dev.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_dev].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dev.name
  location            = azurerm_resource_group.rg_nsg_dev.location
}


module "nsg_log_pfm_dev" {
  for_each                = { for spoke in local.spokes.sb_pfm_dev : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_dev.name
  storage_account_id      = azurerm_storage_account.netw_sa_pfm_dev.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_pfm_dev[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_dev[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_dev_01
  }
}



resource "azurerm_storage_account" "netw_sa_id_prod" {
  provider            = azurerm.sb_id_prod
  name                = "${local.subscriptions_map.sb_id_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_id_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_id_prod.name
  location            = azurerm_resource_group.rg_nsg_id_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_id_prod" {
  provider            = azurerm.sb_id_prod
  name                = "${local.subscriptions_map.sb_id_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_id_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_id_prod.name
  location            = azurerm_resource_group.rg_nsg_id_prod.location
}


module "nsg_log_id_prod" {
  for_each                = { for spoke in local.spokes.sb_id_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_id_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_id_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_id_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_id_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_id_prod
  }
}


resource "azurerm_storage_account" "netw_sa_itt_prod" {
  provider            = azurerm.sb_itt_prod
  name                = "${local.subscriptions_map.sb_itt_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_itt_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itt_prod.name
  location            = azurerm_resource_group.rg_nsg_itt_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_itt_prod" {
  provider            = azurerm.sb_itt_prod
  name                = "${local.subscriptions_map.sb_itt_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_itt_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itt_prod.name
  location            = azurerm_resource_group.rg_nsg_itt_prod.location
}


module "nsg_log_itt_prod" {
  for_each                = { for spoke in local.spokes.sb_itt_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_itt_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_itt_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_itt_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_itt_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_itt_prod
  }
}



resource "azurerm_storage_account" "netw_sa_dvp_prod" {
  provider            = azurerm.sb_dvp_prod
  name                = "${local.subscriptions_map.sb_dvp_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_dvp_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dvp_prod.name
  location            = azurerm_resource_group.rg_nsg_dvp_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_dvp_prod" {
  provider            = azurerm.sb_dvp_prod
  name                = "${local.subscriptions_map.sb_dvp_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_dvp_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dvp_prod.name
  location            = azurerm_resource_group.rg_nsg_dvp_prod.location
}


module "nsg_log_dvp_prod" {
  for_each                = { for spoke in local.spokes.sb_dvp_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_dvp_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_dvp_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_dvp_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_dvp_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_dvp_prod
  }
}



resource "azurerm_storage_account" "netw_sa_itm_prod" {
  provider            = azurerm.sb_itm_prod
  name                = "${local.subscriptions_map.sb_itm_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_itm_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itm_prod.name
  location            = azurerm_resource_group.rg_nsg_itm_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_itm_prod" {
  provider            = azurerm.sb_itm_prod
  name                = "${local.subscriptions_map.sb_itm_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_itm_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itm_prod.name
  location            = azurerm_resource_group.rg_nsg_itm_prod.location
}


module "nsg_log_itm_prod" {
  for_each                = { for spoke in local.spokes.sb_itm_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_itm_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_itm_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_itm_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_itm_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_itm_prod
  }
}



resource "azurerm_storage_account" "netw_sa_sec_prod" {
  provider            = azurerm.sb_sec_prod
  name                = "${local.subscriptions_map.sb_sec_prod.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_sec_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_sec_prod.name
  location            = azurerm_resource_group.rg_nsg_sec_prod.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_sec_prod" {
  provider            = azurerm.sb_sec_prod
  name                = "${local.subscriptions_map.sb_sec_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_sec_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_sec_prod.name
  location            = azurerm_resource_group.rg_nsg_sec_prod.location
}


module "nsg_log_sec_prod" {
  for_each                = { for spoke in local.spokes.sb_sec_prod : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_sec_prod.name
  storage_account_id      = azurerm_storage_account.netw_sa_sec_prod.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_sec_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_sec_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_sec_prod
  }
}


resource "azurerm_storage_account" "netw_sa_cpo_prod_us" {
  provider            = azurerm.sb_cpo_prod_us
  name                = "${local.subscriptions_map.sb_cpo_prod_us.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_us].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_us.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_cpo_prod_us" {
  provider            = azurerm.sb_cpo_prod_us
  name                = "${local.subscriptions_map.sb_cpo_prod_us.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_us].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_us.location
}


module "nsg_log_cpo_prod_us" {
  for_each                = { for spoke in local.spokes.sb_cpo_prod_us : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_cpo_prod_us.name
  storage_account_id      = azurerm_storage_account.netw_sa_cpo_prod_us.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_cpo_prod_us[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_cpo_prod_us[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_cpo_prod_us
  }
}


resource "azurerm_storage_account" "netw_sa_cpo_prod_ci" {
  provider            = azurerm.sb_cpo_prod_ci
  name                = "${local.subscriptions_map.sb_cpo_prod_ci.netw_sa_acc_name}${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_ci].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_ci.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}


resource "azurerm_network_watcher" "netw_cpo_prod_ci" {
  provider            = azurerm.sb_cpo_prod_ci
  name                = "${local.subscriptions_map.sb_cpo_prod_ci.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_ci].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_ci.location
}


module "nsg_log_cpo_prod_ci" {
  for_each                = { for spoke in local.spokes.sb_cpo_prod_ci : spoke.name => spoke }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_cpo_prod_ci.name
  storage_account_id      = azurerm_storage_account.netw_sa_cpo_prod_ci.id
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsgs                    = module.spokes_sb_cpo_prod_ci[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_cpo_prod_ci[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_cpo_prod_ci
  }
}
