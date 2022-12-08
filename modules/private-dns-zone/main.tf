resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_private_dns_zone" "pvt_dns_zones" {
  for_each            = { for zone in var.zones : zone => zone }
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = all
  }
}
