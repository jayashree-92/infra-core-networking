# Vnets by subscription
module "vnets_sb_pfm_prod" {
  for_each    = { for vnet in try(local.subscriptions_map.sb_pfm_prod.vnets, []) : vnet.name => vnet if try(vnet.name, false) != false }
  source      = "../modules/vnet"
  location    = local.config_file.location
  vnet        = each.value
  nsg_rg_name = azurerm_resource_group.rg_nsg_prod.name

  providers = {
    azurerm.vnet = azurerm.sb_pfm_prod_01
  }
}


module "vnets_sb_pfm_qa" {
  for_each    = { for vnet in try(local.subscriptions_map.sb_pfm_qa.vnets, []) : vnet.name => vnet if try(vnet.name, false) != false }
  source      = "../modules/vnet"
  location    = local.config_file.location
  vnet        = each.value
  nsg_rg_name = azurerm_resource_group.rg_nsg_qa.name

  providers = {
    azurerm.vnet = azurerm.sb_pfm_qa_01
  }
}
