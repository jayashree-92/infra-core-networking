output "routes" {
  value = {
    zones   = { for zone in azurerm_private_dns_zone.pvt_dns_zones : zone.name => zone.id }
    rg_name = azurerm_resource_group.rg.name
  }
}
