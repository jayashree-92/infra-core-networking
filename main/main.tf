module "vwan" {
 count = local.create_vwan == true ? 1 : 0
  source = "../modules/vwan"
  vwan = local.vwan_subscription.vwan
  providers = {
    azurerm = azurerm.vwan_hubs
  }
}

module "hubs" {
  source   = "../modules/hub"
  for_each = { for hub in local.vwan_subscription.hubs : hub.name => hub }
  location = local.config_file.location
  hub      = each.value
  vwan = {
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_id
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : data.terraform_remote_state.vwan[0].outputs.vwan.vwan_rg_name
  }

  providers = {
    azurerm = azurerm.vwan_hubs
  }
}


# # Vnets-spokes by subscription

# module "pfm_qa_spokes" {
#   for_each = { for spoke in local.spokes.spoke_pfm_qa_uc_01 : spoke.name => spoke }

#   source = "../modules/vnet-spoke"

#   virtual_hub_id = module.hubs[each.value.virtual_hub_name].hub.id
#   spoke          = each.value

#   providers = {
#     azurerm.spoke = azurerm.sb_pfm_qa_uc_01
#     azurerm.hub   = azurerm.hub
#   }
# }

# NSGS
