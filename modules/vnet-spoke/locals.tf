# locals {
#   locations_short = {
#     "Central US"    = "uc"
#     "East US 2"     = "eu"
#     "Central India" = "ci"
#   }
#   environments_short = {
#     "prod"    = "p"
#     "preprod" = "pprod"
#     "dev"     = "dev"
#   }
#   resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
#   location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
#   if_ddos_enabled     = var.create_ddos_plan ? [{}] : []
#   location_short      = coalesce(var.location_short, local.locations_short[var.location])
#   environment_short   = coalesce(var.location_short, local.environments_short[var.environment_code])
#   rand                = "01" #TODO: GET RAND HERE
#   hub_name            = coalesce(var.hub_name, "HubNet-${local.environment_short}-${local.location_short}-${local.rand}")
#   virtual_hub_id      = coalesce(var.virtual_hub_id, "/subscriptions/${var.subscription_id_hub}/resourceGroups/${var.vwan_rg}/providers/Microsoft.Network/virtualHubs/${local.hub_name}")
# }
