
# Vnets-spokes by subscription
module "spokes_sb_pfm_prod" {
  for_each                                = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_pfm_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_pfm_prod_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_pfm_stg" {
  for_each                                = { for spoke in local.spokes.sb_pfm_stg : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_stg.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_stg.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  environment                             = local.subscriptions_map.sb_pfm_stg.environment
  sb_function                             = local.subscriptions_map.sb_pfm_stg.function

  providers = {
    azurerm.spoke = azurerm.sb_pfm_stg_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_pfm_qa" {
  for_each                                = { for spoke in local.spokes.sb_pfm_qa : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_qa.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_qa.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  environment                             = local.subscriptions_map.sb_pfm_qa.environment
  sb_function                             = local.subscriptions_map.sb_pfm_qa.function

  providers = {
    azurerm.spoke = azurerm.sb_pfm_qa_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_pfm_dev" {
  for_each                                = { for spoke in local.spokes.sb_pfm_dev : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_dev.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_dev.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  environment                             = local.subscriptions_map.sb_pfm_dev.environment
  sb_function                             = local.subscriptions_map.sb_pfm_dev.function

  providers = {
    azurerm.spoke = azurerm.sb_pfm_dev_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_id_prod" {
  for_each                                = { for spoke in local.spokes.sb_id_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_id_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_id_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_id_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_id_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_itt_prod" {
  for_each                                = { for spoke in local.spokes.sb_itt_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_itt_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_itt_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_itt_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_itt_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_dvp_prod" {
  for_each                                = { for spoke in local.spokes.sb_dvp_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_dvp_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_dvp_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_dvp_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_dvp_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_itm_prod" {
  for_each                                = { for spoke in local.spokes.sb_itm_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_itm_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_itm_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_itm_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_itm_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_sec_prod" {
  for_each                                = { for spoke in local.spokes.sb_sec_prod : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_sec_prod.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_sec_prod.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_sec_prod.function

  providers = {
    azurerm.spoke = azurerm.sb_sec_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_cpo_prod_us" {
  for_each                                = { for spoke in local.spokes.sb_cpo_prod_us : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_cpo_prod_us.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_cpo_prod_us.function

  providers = {
    azurerm.spoke = azurerm.sb_cpo_prod_us
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_cpo_prod_ci" {
  for_each                                = { for spoke in local.spokes.sb_cpo_prod_ci : spoke.name => spoke }
  source                                  = "../modules/vnet-spoke"
  location                                = local.config_file.location
  nsg_rg_name                             = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  nsg_rg_location                         = azurerm_resource_group.rg_nsg_cpo_prod_ci.location
  virtual_hub_id                          = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  spoke                                   = each.value
  sb_function                             = local.subscriptions_map.sb_cpo_prod_ci.function

  providers = {
    azurerm.spoke = azurerm.sb_cpo_prod_ci
    azurerm.hub   = azurerm.vwan_hubs
  }
}
