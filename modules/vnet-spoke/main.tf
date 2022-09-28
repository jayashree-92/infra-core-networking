resource "azurerm_resource_group" "rg" {
  provider = azurerm.spoke
  name     = coalesce(try(var.spoke.resource_group.legacy_name, ""), var.spoke.resource_group.name)
  location = var.spoke.resource_group.location
  tags     = var.spoke.resource_group.tags
}

resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.spoke
  name                = coalesce(try(var.spoke.legacy_name, ""), var.spoke.name)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.spoke.address_space
  dns_servers         = var.spoke.dns_servers
  tags                = var.spoke.tags
}

resource "azurerm_virtual_hub_connection" "vhc" {
  provider                  = azurerm.hub
  name                      = var.spoke.virtual_hub_connection_name
  remote_virtual_network_id = trimsuffix(azurerm_virtual_network.vnet.id, "/")
  virtual_hub_id            = var.virtual_hub_id
}

resource "azurerm_subnet" "snet" {
  provider             = azurerm.spoke
  for_each             = { for subnet in var.spoke.subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}



# resource "azurerm_network_ddos_protection_plan" "ddos" {
#   provider            = azurerm.spoke
#   count               = var.create_ddos_plan ? 1 : 0
#   name                = lower("${var.spoke_vnet_name}-ddos-protection-plan")
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   tags                = merge({ "ResourceName" = lower("${var.spoke_vnet_name}-ddos-protection-plan") }, var.tags, )
# }

