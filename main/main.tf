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

output "rid_hubs" {
  value = random_string.rid_hubs
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

module "spokes_sb_pfm_prod" {
  for_each       = { for spoke in local.spokes.sb_pfm_prod : spoke.name => spoke }
  source         = "../modules/vnet-spoke"
  location       = local.config_file.location
  nsg_rg_name    = local.subscriptions_map.sb_pfm_prod.nsg_rg_name
  virtual_hub_id = module.hubs[each.value.virtual_hub_name].hub.id
  spoke          = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_prod_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}

module "spokes_sb_pfm_stg" {
  for_each       = { for spoke in local.spokes.sb_pfm_stg : spoke.name => spoke }
  source         = "../modules/vnet-spoke"
  location       = local.config_file.location
  nsg_rg_name    = local.subscriptions_map.sb_pfm_stg.nsg_rg_name
  virtual_hub_id = module.hubs[each.value.virtual_hub_name].hub.id
  spoke          = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_stg_01
    azurerm.hub   = azurerm.vwan_hubs
  }
}
