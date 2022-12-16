# Vnets-spokes by subscription
module "spokes_sb_pfm_prod" {
  for_each                                   = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_prod.location
  routes                                     = module.routes_pfm_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_pfm_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones
  providers = {
    azurerm.spoke = azurerm.sb_pfm_prod_01
    azurerm.hub   = azurerm.sb_net_prod
  }
}

module "spokes_sb_pfm_stg" {
  for_each                                   = { for spoke in local.spokes.sb_pfm_stg : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_stg.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_stg.location
  routes                                     = module.routes_pfm_stg.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  environment                                = local.subscriptions_map.sb_pfm_stg.environment
  sb_function                                = local.subscriptions_map.sb_pfm_stg.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_pfm_stg_01
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_pfm_qa" {
  for_each                                   = { for spoke in local.spokes.sb_pfm_qa : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_qa.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_qa.location
  routes                                     = module.routes_pfm_qa.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  environment                                = local.subscriptions_map.sb_pfm_qa.environment
  sb_function                                = local.subscriptions_map.sb_pfm_qa.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_pfm_qa_01
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_pfm_dev" {
  for_each                                   = { for spoke in local.spokes.sb_pfm_dev : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_dev.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_dev.location
  routes                                     = module.routes_pfm_dev.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  environment                                = local.subscriptions_map.sb_pfm_dev.environment
  sb_function                                = local.subscriptions_map.sb_pfm_dev.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_pfm_dev_01
    azurerm.hub   = azurerm.sb_net_prod
  }
}

module "spokes_sb_id_prod" {
  for_each                                   = { for spoke in local.spokes.sb_id_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_id_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_id_prod.location
  routes                                     = module.routes_id_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_id_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_id_prod
    azurerm.hub   = azurerm.sb_net_prod
  }
}

module "spokes_sb_itt_prod" {
  for_each                                   = { for spoke in local.spokes.sb_itt_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_itt_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_itt_prod.location
  routes                                     = module.routes_itt_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_itt_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_itt_prod
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_dvp_prod" {
  for_each                                   = { for spoke in local.spokes.sb_dvp_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_dvp_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_dvp_prod.location
  routes                                     = module.routes_dvp_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_dvp_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_dvp_prod
    azurerm.hub   = azurerm.sb_net_prod
  }
}

module "spokes_sb_itm_prod" {
  for_each                                   = { for spoke in local.spokes.sb_itm_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_itm_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_itm_prod.location
  routes                                     = module.routes_itm_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_itm_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_itm_prod
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_sec_prod" {
  for_each                                   = { for spoke in local.spokes.sb_sec_prod : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_sec_prod.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_sec_prod.location
  routes                                     = module.routes_sec_prod.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_sec_prod.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_sec_prod
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_cpo_prod_us" {
  for_each                                   = { for spoke in local.spokes.sb_cpo_prod_us : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_cpo_prod_us.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_cpo_prod_us.location
  routes                                     = module.routes_cpo_prod_us.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_cpo_prod_us.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_cpo_prod_us
    azurerm.hub   = azurerm.sb_net_prod
  }
}


module "spokes_sb_cpo_prod_ci" {
  for_each                                   = { for spoke in local.spokes.sb_cpo_prod_ci : spoke.name => spoke }
  source                                     = "../modules/vnet-spoke"
  propagate_not_secure_vitual_hub_connection = local.config_file.propagate_not_secure_vitual_hub_connection
  location                                   = local.config_file.location
  nsg_rg_name                                = azurerm_resource_group.rg_nsg_cpo_prod_ci.name
  nsg_rg_location                            = azurerm_resource_group.rg_nsg_cpo_prod_ci.location
  routes                                     = module.routes_cpo_prod_ci.route_tables
  virtual_hub_id                             = module.hubs[each.value.virtual_hub_name].hub.id
  virtual_hub_firewall_private_ip_address    = module.hubs[each.value.virtual_hub_name].hub.firewall.virtual_hub[0].private_ip_address
  virtual_hub_default_route_table_id         = module.hubs[each.value.virtual_hub_name].hub.default_route_table_id
  spoke                                      = each.value
  sb_function                                = local.subscriptions_map.sb_cpo_prod_ci.function
  private_dns_zones                          = local.create_private_dns_zones == true ? module.private_dns_zones[0] : data.terraform_remote_state.private_dns_zones[0].outputs.private_dns_zones

  providers = {
    azurerm.spoke = azurerm.sb_cpo_prod_ci
    azurerm.hub   = azurerm.sb_net_prod
  }
}
