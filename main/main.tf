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
  source   = "../modules/hub"
  for_each = { for hub in local.vwan_subscription.hubs : hub.name => hub }
  location = local.config_file.location
  rid_hub  = random_string.rid_hubs[each.value.name].result
  hub      = each.value
  vwan = {
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_id
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_rg_name
  }

  providers = {
    azurerm = azurerm.vwan_hubs
  }
}

# Vnets-spokes by subscription
resource "random_string" "nsg_rg_rids" {
  for_each    = toset(local.nsg_rg_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

# FOR PFM WILL RENAME THE RESOURCE AFTER TO rg_nsg_pfm_prod
resource "azurerm_resource_group" "rg_nsg_prod" {
  provider = azurerm.sb_pfm_prod_01
  name     = "${local.subscriptions_map.sb_pfm_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_prod].result}"
  location = local.config_file.location
}

# FOR PFM WILL RENAME THE RESOURCE AFTER TO rg_nsg_pfm_stg
resource "azurerm_resource_group" "rg_nsg_stg" {
  provider = azurerm.sb_pfm_stg_01
  name     = "${local.subscriptions_map.sb_pfm_stg.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_stg].result}"
  location = local.config_file.location
}

# FOR PFM WILL RENAME THE RESOURCE AFTER TO rg_nsg_pfm_qa
resource "azurerm_resource_group" "rg_nsg_qa" {
  provider = azurerm.sb_pfm_qa_01
  name     = "${local.subscriptions_map.sb_pfm_qa.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_qa].result}"
  location = local.config_file.location
}

# FOR PFM WILL RENAME THE RESOURCE AFTER TO rg_nsg_pfm_dev
resource "azurerm_resource_group" "rg_nsg_dev" {
  provider = azurerm.sb_pfm_dev_01
  name     = "${local.subscriptions_map.sb_pfm_dev.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_dev].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_id_prod" {
  provider = azurerm.sb_id_prod
  name     = "${local.subscriptions_map.sb_id_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_id_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_itt_prod" {
  provider = azurerm.sb_id_prod
  name     = "${local.subscriptions_map.sb_itt_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_itt_prod].result}"
  location = local.config_file.location
}

module "spokes_sb_pfm_prod" {
  for_each        = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_prod.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_prod.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_prod_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_pfm_stg" {
  for_each        = { for spoke in local.spokes.sb_pfm_stg : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_stg.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_stg.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_stg_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_pfm_qa" {
  for_each        = { for spoke in local.spokes.sb_pfm_qa : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_qa.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_qa.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_qa_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}


module "spokes_sb_pfm_dev" {
  for_each        = { for spoke in local.spokes.sb_pfm_dev : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_dev.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_dev.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_dev_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_id_prod" {
  for_each        = { for spoke in local.spokes.sb_id_prod : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_id_prod.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_id_prod.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_id_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_itt_prod" {
  for_each        = { for spoke in local.spokes.sb_itt_prod : spoke.name => spoke }
  source          = "../modules/vnet-spoke"
  location        = local.config_file.location
  nsg_rg_name     = azurerm_resource_group.rg_nsg_itt_prod.name
  nsg_rg_location = azurerm_resource_group.rg_nsg_itt_prod.location
  virtual_hub_id  = module.hubs[each.value.virtual_hub_name].hub.id
  spoke           = each.value

  providers = {
    azurerm.spoke = azurerm.sb_itt_prod
    azurerm.hub   = azurerm.vwan_hubs
  }
}