locals {
  config_file   = yamldecode(file("../deployments/configs.yaml"))
  subscriptions = local.config_file.subscriptions
  vwan          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].vwan
  hubs          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].hubs
}

output "vwan" {
  value = module.vwan
}

output "hubs" {
  value = module.hubs
}

module "vwan" {
  source = "../modules/vwan"

  vwan = local.vwan

  providers = {
    azurerm = azurerm.sbnetprod01
  }
}

module "hubs" {
  source   = "../modules/hub"
  for_each = { for hub in local.hubs : hub.name => hub }
  hub      = each.value
  vwan = {
    id      = module.vwan.vwan_id
    rg_name = module.vwan.vwan_rg_name
  }

  providers = {
    azurerm = azurerm.sbnetprod01
  }
}

# Vnets-spokes by subscription

# NSGS
