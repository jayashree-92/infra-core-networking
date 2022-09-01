locals {
  devops_vnet_config_map               = lookup(var.vnet_config_map, "vnet-spoke-devops-01")
  platform_vnet_pprod_config_map       = lookup(var.vnet_config_map, "vnet-spoke-platform-pprod-01")
  platform_vnet_prod_config_map        = lookup(var.vnet_config_map, "vnet-spoke-platform-prod-01")
  platform_vnet_appgw_pprod_config_map = lookup(var.vnet_config_map, "vnet-spoke-platform-appgw-pprod-01")
}

module "vnet-spoke-devops-01" {
  source = "../modules/vnet-spoke"

  dep_generic_map = local.dep_generic_map

  subscription_id_hub   = local.devops_vnet_config_map.subscription_id_hub
  subscription_id_spoke = local.devops_vnet_config_map.subscription_id_spoke

  location        = var.location
  spoke_vnet_name = local.devops_vnet_config_map.spoke_vnet_name
  suffix_number   = local.devops_vnet_config_map.suffix_number

  vnet_address_space = local.devops_vnet_config_map.vnet_address_space
  dns_servers        = var.dns_servers

  create_hub_connection = true
  virtual_hub_id        = var.virtual_hub_id

  subnets = local.devops_vnet_config_map.subnets

  tags = {}
}

module "vnet-spoke-platform-prod-01" {
  source = "../modules/vnet-spoke"

  dep_generic_map = local.dep_generic_map

  subscription_id_hub   = local.platform_vnet_prod_config_map.subscription_id_hub
  subscription_id_spoke = local.platform_vnet_prod_config_map.subscription_id_spoke

  location        = var.location
  spoke_vnet_name = local.platform_vnet_prod_config_map.spoke_vnet_name
  suffix_number   = local.platform_vnet_prod_config_map.suffix_number

  vnet_address_space = local.platform_vnet_prod_config_map.vnet_address_space
  dns_servers        = var.dns_servers

  create_hub_connection = true
  virtual_hub_id        = var.virtual_hub_id

  subnets = local.platform_vnet_prod_config_map.subnets

  tags = {}
}


module "vnet-spoke-client-pprod-01" {
  source = "../modules/vnet-spoke"

  dep_generic_map = local.dep_pprod_map

  subscription_id_hub   = local.platform_vnet_pprod_config_map.subscription_id_hub
  subscription_id_spoke = local.platform_vnet_pprod_config_map.subscription_id_spoke

  location        = var.location
  spoke_vnet_name = local.platform_vnet_pprod_config_map.spoke_vnet_name
  suffix_number   = local.platform_vnet_pprod_config_map.suffix_number

  vnet_address_space = local.platform_vnet_pprod_config_map.vnet_address_space
  dns_servers        = var.dns_servers

  create_hub_connection = true
  virtual_hub_id        = var.virtual_hub_id

  subnets = local.platform_vnet_pprod_config_map.subnets

  tags = {}
}


module "vnet-spoke-client-appgw-pprod-01" {
  source = "../modules/vnet-spoke"

  dep_generic_map = local.dep_pprod_map

  subscription_id_hub   = local.platform_vnet_appgw_pprod_config_map.subscription_id_hub
  subscription_id_spoke = local.platform_vnet_appgw_pprod_config_map.subscription_id_spoke

  location        = var.location
  spoke_vnet_name = local.platform_vnet_appgw_pprod_config_map.spoke_vnet_name
  suffix_number   = local.platform_vnet_appgw_pprod_config_map.suffix_number

  vnet_address_space = local.platform_vnet_appgw_pprod_config_map.vnet_address_space
  dns_servers        = var.dns_servers

  create_hub_connection = true
  virtual_hub_id        = var.virtual_hub_id

  subnets = local.platform_vnet_appgw_pprod_config_map.subnets

  tags = {}
}