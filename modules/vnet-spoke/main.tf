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
  provider = azurerm.spoke
  name     = coalesce(try(var.spoke.resource_group.legacy_name, ""), "${var.spoke.resource_group.name}-${random_string.rids[local.rg_vnet_key].result}")
  location = var.location
  tags     = var.spoke.resource_group.tags
}

resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.spoke
  name                = coalesce(try(var.spoke.legacy_name, ""), "${var.spoke.name}-${random_string.rids[local.vnet_key].result}")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.spoke.address_space
  dns_servers         = var.spoke.dns_servers
  tags                = var.spoke.tags
}

resource "azurerm_virtual_hub_connection" "vhc" {
  provider                  = azurerm.hub
  name                      = "${var.spoke.virtual_hub_connection_name}-${random_string.rids[local.vhc_key].result}"
  remote_virtual_network_id = trimsuffix(azurerm_virtual_network.vnet.id, "/")
  virtual_hub_id            = var.virtual_hub_id
}

resource "azurerm_subnet" "subnets" {
  provider             = azurerm.spoke
  for_each             = { for subnet in var.spoke.subnets : subnet.name => subnet }
  name                 = "${each.key}-${random_string.rids[each.key].result}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}


# DO NOT USE NETWORK SECURITY RULES IN-LINE WITHIN THE FOLLOWING RESOURCE
resource "azurerm_network_security_group" "nsgs" {
  provider            = azurerm.spoke
  for_each            = { for subnet in var.spoke.subnets : subnet.nsg_name => subnet }
  name                = "${each.key}-${random_string.rids[each.key].result}"
  location            = var.nsg_rg_location
  resource_group_name = var.nsg_rg_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  provider                  = azurerm.spoke
  for_each                  = { for subnet in var.spoke.subnets : subnet.name => subnet }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_name].id
}
