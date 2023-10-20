module "private_dns_zones" {
  count    = local.create_private_dns_zones == true ? 1 : 0
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Innocap/Terraform-Modules/terraform-azurerm-private-dns-zone//module//?ref=v1.0.0"
  location = local.config_file.location
  rg_name  = local.vwan_subscription.private_dns_zones.resource_group.name
  zones    = local.vwan_subscription.private_dns_zones.zones

  providers = {
    azurerm = azurerm.sb_net_prod
  }
}
