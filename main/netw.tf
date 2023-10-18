resource "random_string" "sa_netw_rids" {
  for_each    = toset(local.sb_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}


module "netw_sa_net_prod" {
  count  = try(local.subscriptions_map.sb_net_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_net_prod.name
  location                          = azurerm_resource_group.rg_nsg_net_prod.location
  storage_account_name              = local.subscriptions_map.sb_net_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_net_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_net_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_net_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_net_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_net_prod["vnet-${local.subscriptions_map.sb_net_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_net_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_net_prod["vnet-${local.subscriptions_map.sb_net_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_net_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_net_prod["vnet-${local.subscriptions_map.sb_net_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_net_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_net_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_net_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_net_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_net_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_net_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_prod
  ]

}

resource "azurerm_network_watcher" "netw_net_prod" {
  provider            = azurerm.sb_net_prod
  name                = "${local.vwan_subscription.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_net_prod].result}"
  location            = azurerm_resource_group.rg_nsg_net_prod.location
  resource_group_name = azurerm_resource_group.rg_nsg_net_prod.name
}

module "nsg_log_net_prod" {
  for_each                = { for spoke in local.spokes.sb_net_prod : spoke.name => spoke if try(local.subscriptions_map.sb_net_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_net_prod.name
  storage_account_id      = length(module.netw_sa_net_prod) > 0 ? module.netw_sa_net_prod[0].id : null
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_net_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_net_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_net_prod
  }
}


module "netw_sa_pfm_prod" {
  count  = try(local.subscriptions_map.sb_pfm_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_prod.name
  location                          = azurerm_resource_group.rg_nsg_prod.location
  storage_account_name              = local.subscriptions_map.sb_pfm_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_pfm_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_pfm_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_pfm_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_pfm_prod["vnet-${local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_pfm_prod["vnet-${local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_pfm_prod["vnet-${local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_pfm_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_pfm_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_pfm_prod_01
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_prod
  ]
}


resource "azurerm_network_watcher" "netw_pfm_prod" {
  provider            = azurerm.sb_pfm_prod_01
  name                = "${local.subscriptions_map.sb_pfm_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_prod].result}"
  location            = azurerm_resource_group.rg_nsg_prod.location
  resource_group_name = azurerm_resource_group.rg_nsg_prod.name
}


module "nsg_log_pfm_prod" {
  for_each                = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke if try(local.subscriptions_map.sb_pfm_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_prod.name
  storage_account_id      = length(module.netw_sa_pfm_prod) > 0 ? module.netw_sa_pfm_prod[0].id : null
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_pfm_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_prod_01
  }
}

######################################
#  nsg log flow for non spoke vnets
######################################
module "nsg_log_pfm_prod_vnets" {
  for_each                = { for vnet in try(local.subscriptions_map.sb_pfm_prod.vnets, []) : vnet.name => vnet if try(vnet.name, false) != false && try(local.subscriptions_map.sb_pfm_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_prod.name
  storage_account_id      = try(module.netw_sa_pfm_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.vnets_sb_pfm_prod[each.key].vnet.nsgs
  spoke                   = module.vnets_sb_pfm_prod[each.key].vnet

  providers = {
    azurerm = azurerm.sb_pfm_prod_01
  }

  depends_on = [
    azurerm_network_watcher.netw_pfm_prod
  ]
}

module "netw_sa_pfm_tst" {
  count  = try(local.subscriptions_map.sb_pfm_tst.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_tst.name
  location                          = azurerm_resource_group.rg_nsg_tst.location
  storage_account_name              = local.subscriptions_map.sb_pfm_tst.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_pfm_tst.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_pfm_tst.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_pfm_tst].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_pfm_tst["vnet-${local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_tst.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_pfm_tst["vnet-${local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_tst.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_pfm_tst["vnet-${local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_tst.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_tst.environment}-${local.location_code}-${local.subscriptions_map.sb_pfm_tst.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_pfm_tst.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_pfm_stg_01
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_tst
  ]
}

resource "azurerm_network_watcher" "netw_pfm_tst" {
  provider            = azurerm.sb_pfm_stg_01
  name                = "${local.subscriptions_map.sb_pfm_tst.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_tst].result}"
  location            = azurerm_resource_group.rg_nsg_tst.location
  resource_group_name = azurerm_resource_group.rg_nsg_tst.name
}

module "nsg_log_pfm_tst" {
  for_each                = { for spoke in local.spokes.sb_pfm_tst : spoke.name => spoke if try(local.subscriptions_map.sb_pfm_tst.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_tst.name
  storage_account_id      = try(module.netw_sa_pfm_tst[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_pfm_tst[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_tst[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_stg_01
  }

  depends_on = [
    azurerm_network_watcher.netw_pfm_tst
  ]
}

module "netw_sa_pfm_qa" {
  count  = try(local.subscriptions_map.sb_pfm_qa.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_qa.name
  location                          = azurerm_resource_group.rg_nsg_qa.location
  storage_account_name              = local.subscriptions_map.sb_pfm_qa.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_pfm_qa.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_pfm_qa.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_pfm_qa].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_pfm_qa["vnet-${local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_qa.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_pfm_qa["vnet-${local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_qa.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_pfm_qa["vnet-${local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_qa.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_qa.environment}-${local.location_code}-${local.subscriptions_map.sb_pfm_qa.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_pfm_qa.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_pfm_qa_01
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_qa
  ]
}


resource "azurerm_network_watcher" "netw_pfm_qa" {
  provider            = azurerm.sb_pfm_qa_01
  name                = "${local.subscriptions_map.sb_pfm_qa.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_qa].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_qa.name
  location            = azurerm_resource_group.rg_nsg_qa.location
}


module "nsg_log_pfm_qa" {
  for_each                = { for spoke in local.spokes.sb_pfm_qa : spoke.name => spoke if try(local.subscriptions_map.sb_pfm_qa.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_qa.name
  storage_account_id      = try(module.netw_sa_pfm_qa[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_pfm_qa[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_qa[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_qa_01
  }

  depends_on = [
    azurerm_network_watcher.netw_pfm_qa
  ]
}

######################################
#  nsg log flow for non spoke vnets
######################################
module "nsg_log_pfm_qa_vnets" {
  for_each                = { for vnet in try(local.subscriptions_map.sb_pfm_qa.vnets, []) : vnet.name => vnet if try(vnet.name, false) != false && try(local.subscriptions_map.sb_pfm_qa.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_qa.name
  storage_account_id      = try(module.netw_sa_pfm_qa[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.vnets_sb_pfm_qa[each.key].vnet.nsgs
  spoke                   = module.vnets_sb_pfm_qa[each.key].vnet

  providers = {
    azurerm = azurerm.sb_pfm_qa_01
  }

  depends_on = [
    azurerm_network_watcher.netw_pfm_qa
  ]
}

module "netw_sa_pfm_dev" {
  count  = try(local.subscriptions_map.sb_pfm_dev.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_dev.name
  location                          = azurerm_resource_group.rg_nsg_dev.location
  storage_account_name              = local.subscriptions_map.sb_pfm_dev.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_pfm_dev.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_pfm_dev.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_pfm_dev].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_pfm_dev["vnet-${local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_dev.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_pfm_dev["vnet-${local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_dev.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_pfm_dev["vnet-${local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_dev.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_pfm_dev.environment}-${local.location_code}-${local.subscriptions_map.sb_pfm_dev.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_pfm_dev.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_pfm_dev_01
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_dev
  ]
}

resource "azurerm_network_watcher" "netw_pfm_dev" {
  provider            = azurerm.sb_pfm_dev_01
  name                = "${local.subscriptions_map.sb_pfm_dev.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_pfm_dev].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dev.name
  location            = azurerm_resource_group.rg_nsg_dev.location
}


module "nsg_log_pfm_dev" {
  for_each                = { for spoke in local.spokes.sb_pfm_dev : spoke.name => spoke if try(local.subscriptions_map.sb_pfm_dev.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_pfm_dev.name
  storage_account_id      = try(module.netw_sa_pfm_dev[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_pfm_dev[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_pfm_dev[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_pfm_dev_01
  }

  depends_on = [
    azurerm_network_watcher.netw_pfm_dev
  ]
}

module "netw_sa_id_prod" {
  count  = try(local.subscriptions_map.sb_id_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_id_prod.name
  location                          = azurerm_resource_group.rg_nsg_id_prod.location
  storage_account_name              = local.subscriptions_map.sb_id_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_id_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_id_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_id_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_id_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_id_prod["vnet-${local.subscriptions_map.sb_id_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_id_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_id_prod["vnet-${local.subscriptions_map.sb_id_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_id_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_id_prod["vnet-${local.subscriptions_map.sb_id_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_id_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_id_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_id_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_id_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_id_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_id_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_id_prod,
  ]
}


resource "azurerm_network_watcher" "netw_id_prod" {
  provider            = azurerm.sb_id_prod
  name                = "${local.subscriptions_map.sb_id_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_id_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_id_prod.name
  location            = azurerm_resource_group.rg_nsg_id_prod.location
}


module "nsg_log_id_prod" {
  for_each                = { for spoke in local.spokes.sb_id_prod : spoke.name => spoke if try(local.subscriptions_map.sb_id_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_id_prod.name
  storage_account_id      = try(module.netw_sa_id_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_id_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_id_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_id_prod
  }

  depends_on = [
    azurerm_network_watcher.netw_id_prod,
  ]
}

module "netw_sa_itt_prod" {
  count  = try(local.subscriptions_map.sb_itt_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_itt_prod.name
  location                          = azurerm_resource_group.rg_nsg_itt_prod.location
  storage_account_name              = local.subscriptions_map.sb_itt_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_itt_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_itt_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_itt_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_itt_prod["vnet-${local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itt_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_itt_prod["vnet-${local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itt_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_itt_prod["vnet-${local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itt_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itt_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_itt_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_itt_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_itt_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_itt_prod,
  ]
}


resource "azurerm_network_watcher" "netw_itt_prod" {
  provider            = azurerm.sb_itt_prod
  name                = "${local.subscriptions_map.sb_itt_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_itt_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itt_prod.name
  location            = azurerm_resource_group.rg_nsg_itt_prod.location
}


module "nsg_log_itt_prod" {
  for_each                = { for spoke in local.spokes.sb_itt_prod : spoke.name => spoke if try(local.subscriptions_map.sb_itt_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_itt_prod.name
  storage_account_id      = try(module.netw_sa_itt_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_itt_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_itt_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_itt_prod
  }

  depends_on = [
    azurerm_network_watcher.netw_itt_prod,
    module.netw_sa_itt_prod,
  ]
}

module "netw_sa_dvp_prod" {
  count  = try(local.subscriptions_map.sb_dvp_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_dvp_prod.name
  location                          = azurerm_resource_group.rg_nsg_dvp_prod.location
  storage_account_name              = local.subscriptions_map.sb_dvp_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_dvp_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_dvp_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_dvp_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_dvp_prod["vnet-${local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_dvp_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_dvp_prod["vnet-${local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_dvp_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_dvp_prod["vnet-${local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_dvp_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_dvp_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_dvp_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_dvp_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_dvp_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_dvp_prod,
  ]
}


resource "azurerm_network_watcher" "netw_dvp_prod" {
  provider            = azurerm.sb_dvp_prod
  name                = "${local.subscriptions_map.sb_dvp_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_dvp_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_dvp_prod.name
  location            = azurerm_resource_group.rg_nsg_dvp_prod.location
}


module "nsg_log_dvp_prod" {
  for_each                = { for spoke in local.spokes.sb_dvp_prod : spoke.name => spoke if try(local.subscriptions_map.sb_dvp_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_dvp_prod.name
  storage_account_id      = try(module.netw_sa_dvp_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_dvp_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_dvp_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_dvp_prod
  }

  depends_on = [
    azurerm_network_watcher.netw_dvp_prod,
  ]
}

module "netw_sa_itm_prod" {
  count  = try(local.subscriptions_map.sb_itm_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_itm_prod.name
  location                          = azurerm_resource_group.rg_nsg_itm_prod.location
  storage_account_name              = local.subscriptions_map.sb_itm_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_itm_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_itm_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_itm_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_itm_prod["vnet-${local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itm_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_itm_prod["vnet-${local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itm_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_itm_prod["vnet-${local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itm_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_itm_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_itm_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_itm_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_itm_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_itm_prod,
  ]
}

resource "azurerm_network_watcher" "netw_itm_prod" {
  provider            = azurerm.sb_itm_prod
  name                = "${local.subscriptions_map.sb_itm_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_itm_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_itm_prod.name
  location            = azurerm_resource_group.rg_nsg_itm_prod.location
}


module "nsg_log_itm_prod" {
  for_each                = { for spoke in local.spokes.sb_itm_prod : spoke.name => spoke if try(local.subscriptions_map.sb_itm_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_itm_prod.name
  storage_account_id      = try(module.netw_sa_itm_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_itm_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_itm_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_itm_prod
  }

  depends_on = [
    azurerm_network_watcher.netw_itm_prod,
    module.netw_sa_itm_prod,
  ]
}

module "netw_sa_sec_prod" {
  count  = try(local.subscriptions_map.sb_sec_prod.network_watcher.enabled, true) ? 1 : 0
  source = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"

  resource_group_name               = azurerm_resource_group.rg_nsg_sec_prod.name
  location                          = azurerm_resource_group.rg_nsg_sec_prod.location
  storage_account_name              = local.subscriptions_map.sb_sec_prod.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_sec_prod.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_sec_prod.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_sec_prod].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_sec_prod["vnet-${local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_sec_prod.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_sec_prod["vnet-${local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_sec_prod.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_sec_prod["vnet-${local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_sec_prod.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_sec_prod.environment}-${local.location_code}-${local.subscriptions_map.sb_sec_prod.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_sec_prod.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_sec_prod
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_sec_prod,
  ]
}


resource "azurerm_network_watcher" "netw_sec_prod" {
  provider            = azurerm.sb_sec_prod
  name                = "${local.subscriptions_map.sb_sec_prod.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_sec_prod].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_sec_prod.name
  location            = azurerm_resource_group.rg_nsg_sec_prod.location
}


module "nsg_log_sec_prod" {
  for_each                = { for spoke in local.spokes.sb_sec_prod : spoke.name => spoke if try(local.subscriptions_map.sb_sec_prod.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = azurerm_network_watcher.netw_sec_prod.name
  storage_account_id      = try(module.netw_sa_sec_prod[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_sec_prod[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_sec_prod[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_sec_prod
  }

  depends_on = [
    azurerm_network_watcher.netw_sec_prod,
  ]
}

module "netw_sa_cpo_prod_us" {
  source                            = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"
  count                             = try(local.subscriptions_map.sb_cpo_prod_us.network_watcher.enabled, true) ? 1 : 0
  resource_group_name               = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  location                          = azurerm_resource_group.rg_nsg_cpo_prod_us.location
  storage_account_name              = local.subscriptions_map.sb_cpo_prod_us.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_cpo_prod_us.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_cpo_prod_us.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_us].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_cpo_prod_us["vnet-${local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_us.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_cpo_prod_us["vnet-${local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_us.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_cpo_prod_us["vnet-${local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_us.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_us.environment}-${local.location_code}-${local.subscriptions_map.sb_cpo_prod_us.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_cpo_prod_us.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_cpo_prod_us
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_cpo_prod_us
  ]
}
resource "azurerm_network_watcher" "netw_cpo_prod_us" {
  count               = try(local.subscriptions_map.sb_cpo_prod_us.network_watcher.enabled, true) ? 1 : 0
  provider            = azurerm.sb_cpo_prod_us
  name                = "${local.subscriptions_map.sb_cpo_prod_us.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_us].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_us.location
}

module "nsg_log_cpo_prod_us" {
  for_each                = { for spoke in local.spokes.sb_cpo_prod_us : spoke.name => spoke if try(local.subscriptions_map.sb_cpo_prod_us.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = try(azurerm_network_watcher.netw_cpo_prod_us[0].name, null)
  storage_account_id      = try(module.netw_sa_cpo_prod_us[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_cpo_prod_us[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_cpo_prod_us[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_cpo_prod_us
  }

  depends_on = [
    azurerm_network_watcher.netw_cpo_prod_us
  ]
}

module "netw_sa_cpo_prod_ci" {
  source                            = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"
  count                             = try(local.subscriptions_map.sb_cpo_prod_ci.network_watcher.enabled, true) ? 1 : 0
  resource_group_name               = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  location                          = azurerm_resource_group.rg_nsg_cpo_prod_ci.location
  storage_account_name              = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_cpo_prod_ci.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_ci].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = true
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_cpo_prod_ci["vnet-${local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_ci.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_cpo_prod_ci["vnet-${local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_ci.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_cpo_prod_ci["vnet-${local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_ci.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_cpo_prod_ci.environment}-${local.location_code}-${local.subscriptions_map.sb_cpo_prod_ci.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_cpo_prod_ci.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_cpo_prod_ci
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_cpo_prod_ci
  ]
}

resource "azurerm_network_watcher" "netw_cpo_prod_ci" {
  count               = try(local.subscriptions_map.sb_cpo_prod_ci.network_watcher.enabled, true) ? 1 : 0
  provider            = azurerm.sb_cpo_prod_ci
  name                = "${local.subscriptions_map.sb_cpo_prod_ci.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_cpo_prod_ci].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  location            = azurerm_resource_group.rg_nsg_cpo_prod_ci.location
}

module "nsg_log_cpo_prod_ci" {
  for_each                = { for spoke in local.spokes.sb_cpo_prod_ci : spoke.name => spoke if try(local.subscriptions_map.sb_cpo_prod_ci.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = try(azurerm_network_watcher.netw_cpo_prod_ci[0].name, null)
  storage_account_id      = try(module.netw_sa_cpo_prod_ci[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_cpo_prod_ci[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_cpo_prod_ci[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_cpo_prod_ci
  }

  depends_on = [
    azurerm_network_watcher.netw_cpo_prod_ci,
    module.netw_sa_cpo_prod_ci
  ]
}

module "netw_sa_sb_inno_mtl" {
  source                            = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-storage-account//module?ref=v2.1.3"
  count                             = try(local.subscriptions_map.sb_inno_mtl.network_watcher.enabled, true) ? 1 : 0
  resource_group_name               = azurerm_resource_group.rg_nsg_sb_inno_mtl.name
  location                          = azurerm_resource_group.rg_nsg_sb_inno_mtl.location
  storage_account_name              = local.subscriptions_map.sb_inno_mtl.network_watcher.function
  purpose_name                      = local.subscriptions_map.sb_inno_mtl.network_watcher.purpose
  environment_code                  = local.subscriptions_map.sb_inno_mtl.environment
  use_full_environment_code         = true
  storage_account_name_suffix       = random_string.sa_netw_rids[local.subscription_names.sb_inno_mtl].result
  location_code                     = local.location_code
  skuname                           = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.skuname
  min_tls_version                   = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.min_tls_version
  public_access_enable              = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.public_access_enable
  enable_advanced_threat_protection = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.enable_advanced_threat_protection
  account_kind                      = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.account_kind
  managed_identity_type             = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.managed_identity_type
  large_file_share_enabled          = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.large_file_share_enabled
  cmk_encryption_enable             = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.cmk_encryption_enable
  keyvault_id                       = local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.keyvault_id
  log_analytics_name                = local.config_file.log_analytics_workspace.name
  log_analytics_resource_group_name = local.config_file.log_analytics_workspace.resource_group_name
  enable_private_endpoints = {
    blob = false
    file = false
  }

  enable_diagnostic_settings = {
    table = false
    queue = false
    blob  = true
    file  = true
  }

  private_endpoint_virtual_network_name                = module.spokes_sb_inno_mtl["vnet-${local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_inno_mtl.environment}-${local.location_code}"].vnet_spoke.vnet.name
  private_endpoint_virtual_network_resource_group_name = module.spokes_sb_inno_mtl["vnet-${local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_inno_mtl.environment}-${local.location_code}"].vnet_spoke.vnet.resource_group_name
  private_endpoint_subnet_name                         = module.spokes_sb_inno_mtl["vnet-${local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_inno_mtl.environment}-${local.location_code}"].vnet_spoke.subnets["snet-${local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.private_endpoint.vnet}-${local.subscriptions_map.sb_inno_mtl.environment}-${local.location_code}-${local.subscriptions_map.sb_inno_mtl.network_watcher.storage_account.private_endpoint.snet}"].name
  private_dns_zone_resource_group_name                 = local.subscriptions_map.sb_inno_mtl.network_watcher.private_dns_zone_rg_name

  providers = {
    azurerm               = azurerm.sb_inno_mtl
    azurerm.log_analytics = azurerm.sb_itm_prod
    azurerm.dns_zone      = azurerm.sb_net_prod
  }

  depends_on = [
    azurerm_resource_group.rg_nsg_sb_inno_mtl
  ]
}

resource "azurerm_network_watcher" "netw_sb_inno_mtl" {
  count               = try(local.subscriptions_map.sb_inno_mtl.network_watcher.enabled, true) ? 1 : 0
  provider            = azurerm.sb_inno_mtl
  name                = "${local.subscriptions_map.sb_inno_mtl.netw_name}-${random_string.sa_netw_rids[local.subscription_names.sb_inno_mtl].result}"
  resource_group_name = azurerm_resource_group.rg_nsg_sb_inno_mtl.name
  location            = azurerm_resource_group.rg_nsg_sb_inno_mtl.location
}

module "nsg_log_sb_inno_mtl" {
  for_each                = { for spoke in local.spokes.sb_inno_mtl : spoke.name => spoke if try(local.subscriptions_map.sb_inno_mtl.network_watcher.enabled, true) }
  source                  = "../modules/monitoring"
  network_watcher_name    = try(azurerm_network_watcher.netw_sb_inno_mtl[0].name, null)
  storage_account_id      = try(module.netw_sa_sb_inno_mtl[0].id, null)
  location                = local.config_file.location
  log_analytics_workspace = local.config_file.log_analytics_workspace
  nsg_keys                = { for subnet in each.value.subnets : subnet.nsg_name => subnet.nsg_name if subnet.nsg_name != null }
  nsgs                    = module.spokes_sb_inno_mtl[each.key].vnet_spoke.nsgs
  spoke                   = module.spokes_sb_inno_mtl[each.key].vnet_spoke

  providers = {
    azurerm = azurerm.sb_inno_mtl
  }

  depends_on = [
    azurerm_network_watcher.netw_sb_inno_mtl,
    module.netw_sa_sb_inno_mtl
  ]
}

