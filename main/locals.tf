locals {
  config_file       = yamldecode(file("../deployments/${var.location_code}/configs.yaml"))
  location_code     = local.config_file.location_code
  subscriptions     = local.config_file.subscriptions
  vwan_subscription = try({ for i, sub in local.subscriptions : i => sub if(try(sub.vwan, false) != false) }[0], null)
  create_vwan       = local.vwan_subscription != null
  subscription_ids  = { for sub in local.subscriptions : sub.name => sub.id }

  #   vwan          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].vwan
  #   hubs          = local.subscriptions[index(local.subscriptions.*.name, "Sb-NetHub-Prd-01")].hubs
  #   subscription_ids = {
  #     hubs            = local.vwan.subscription_id
  #     sb_pfm_qa_uc_01 = local.subscriptions[index(local.subscriptions.*.name, "Sb-Client-PProd-US-01")].id
  #   }

  #   spokes = {
  #     spoke_pfm_qa_uc_01 = local.subscriptions[index(local.subscriptions.*.name, "Sb-Client-PProd-US-01")].spokes
  #   }
}
