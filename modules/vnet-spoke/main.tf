# data "azurerm_resource_group" "rgrp" {
#   provider = azurerm.spoke
#   count    = var.create_resource_group == false ? 1 : 0
#   name     = var.resource_group_name
# }

# resource "azurerm_resource_group" "rg" {
#   provider = azurerm.spoke
#   count    = var.create_resource_group ? 1 : 0
#   name     = format("rg-vnet-${var.spoke_vnet_name}-${var.dep_generic_map.full_env_code}-${var.suffix_number}")
#   location = var.location
#   tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
# }

# resource "azurerm_virtual_network" "vnet" {
#   provider            = azurerm.spoke
#   name                = lower("vnet-${var.spoke_vnet_name}-${var.dep_generic_map.full_env_code}-${var.suffix_number}")
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   address_space       = var.vnet_address_space
#   dns_servers         = var.dns_servers
#   tags                = merge({ "ResourceName" = lower("vnet-${var.spoke_vnet_name}-${var.dep_generic_map.full_env_code}-${var.suffix_number}") }, var.tags, )

#   dynamic "ddos_protection_plan" {
#     for_each = local.if_ddos_enabled

#     content {
#       id     = azurerm_network_ddos_protection_plan.ddos[0].id
#       enable = true
#     }
#   }
# }

# resource "azurerm_subnet" "snet" {
#   provider             = azurerm.spoke
#   for_each             = var.subnets
#   name                 = lower(format("snet-%s-${var.spoke_vnet_name}-${var.dep_generic_map.full_env_code}", each.value.subnet_name))
#   resource_group_name  = local.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = each.value.subnet_address_prefix
# }

# resource "azurerm_network_ddos_protection_plan" "ddos" {
#   provider            = azurerm.spoke
#   count               = var.create_ddos_plan ? 1 : 0
#   name                = lower("${var.spoke_vnet_name}-ddos-protection-plan")
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   tags                = merge({ "ResourceName" = lower("${var.spoke_vnet_name}-ddos-protection-plan") }, var.tags, )
# }

# resource "azurerm_virtual_hub_connection" "vhc" {
#   provider                  = azurerm.hub
#   count                     = var.create_hub_connection ? 1 : 0
#   name                      = "peer-${azurerm_virtual_network.vnet.name}"
#   remote_virtual_network_id = azurerm_virtual_network.vnet.id
#   virtual_hub_id            = var.virtual_hub_id
# }
