module "private_dns_zones" {
  count    = local.create_private_dns_zones == true ? 1 : 0
  source   = "../modules/private-dns-zone"
  location = local.config_file.location
  rg_name  = local.vwan_subscription.private_dns_zones.resource_group.name
  zones    = local.vwan_subscription.private_dns_zones.zones

  providers = {
    azurerm = azurerm.sb_net_prod
  }
}
