# Vnets by subscription
module "vnets_sb_pfm_prod" {
  for_each = { for vnet in local.subscriptions_map.sb_pfm_prod.vnets : vnet.name => vnet }
  source   = "../modules/vnet"
  location = local.config_file.location
  vnet     = each.value

  providers = {
    azurerm.vnet = azurerm.sb_pfm_prod_01
  }
}
