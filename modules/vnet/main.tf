resource "random_string" "rids" {
  for_each    = toset(local.rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_resource_group" "rg" {
  provider = azurerm.vnet
  name     = "${var.vnet.resource_group.name}-${random_string.rids[local.rg_vnet_key].result}"
  location = var.location
  tags     = var.vnet.resource_group.tags
}

resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.vnet
  name                = "${var.vnet.name}-${random_string.rids[local.vnet_key].result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet.address_space
  dns_servers         = var.vnet.dns_servers
  tags                = var.vnet.tags
}

resource "azurerm_subnet" "subnets" {
  provider             = azurerm.vnet
  for_each             = { for subnet in var.vnet.subnets : subnet.name => subnet }
  name                 = "${each.key}-${random_string.rids[each.key].result}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
