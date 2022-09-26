locals {
  config_file   = yamldecode(file("../deployments/configs.yaml"))
  subscriptions = local.config_file.subscriptions
  vwan          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].vwan
  hubs          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].hubs
  subscription_ids = {
    hubs            = local.vwan.subscription_id
    sb_pfm_qa_uc_01 = local.subscriptions[index(local.subscriptions.*.name, "Sb-Client-PProd-US-01")].id
  }

  spokes = {
    spoke_pfm_qa_uc_01 = local.subscriptions[index(local.subscriptions.*.name, "Sb-Client-PProd-US-01")].spokes
  }
}

output "vwan" {
  value = module.vwan
}

output "hubs" {
  value = module.hubs
}

output "vhub_ud_test" {
  value = module.hubs["vhub-net-prod-uc-01"].hub.id
}

module "vwan" {
  source = "../modules/vwan"

  vwan = local.vwan

  providers = {
    azurerm = azurerm.hub
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
    azurerm.hub = azurerm.hub
  }
}


# Vnets-spokes by subscription

module "pfm_qa_spokes" {
  for_each = { for spoke in local.spokes.spoke_pfm_qa_uc_01 : spoke.name => spoke }

  source = "../modules/vnet-spoke"

  virtual_hub_id = module.hubs[each.value.virtual_hub_name].hub.id
  spoke          = each.value

  providers = {
    azurerm.spoke = azurerm.sb_pfm_qa_uc_01
    azurerm.hub   = azurerm.hub
  }
}

# NSGS
