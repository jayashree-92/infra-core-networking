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

  subscription_names = {
    sb_pfm_prod = "sb-pfm-prod-1a4d"
    sb_pfm_stg  = "sb-pfm-stg-01"
    sb_pfm_qa   = "sb-pfm-qa-1a4d"
    sb_pfm_dev  = "sb-pfm-dev-1a4d"
    sb_id_prod  = "sb-Id-prod-1a4d"
    sb_itt_prod  = "sb-itt-prod-1a4d"
  }

  subscriptions_map = {
    sb_pfm_prod = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_prod)]
    sb_pfm_stg  = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_stg)]
    sb_pfm_qa   = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_qa)]
    sb_pfm_dev  = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_dev)]
    sb_id_prod  = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_id_prod)]
    sb_itt_prod  = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_itt_prod)]
  }

  spokes = {
    sb_pfm_prod = local.subscriptions_map.sb_pfm_prod.spokes
    sb_pfm_stg  = local.subscriptions_map.sb_pfm_stg.spokes
    sb_pfm_qa   = local.subscriptions_map.sb_pfm_qa.spokes
    sb_pfm_dev  = local.subscriptions_map.sb_pfm_dev.spokes
    sb_id_prod  = local.subscriptions_map.sb_id_prod.spokes
    sb_itt_prod  = local.subscriptions_map.sb_itt_prod.spokes
  }

  nsg_rg_rid_keys = [for sb_name in local.subscription_names : sb_name ]


  # config_files = fileset("../deployments/${var.location_code}/", "*configs.yaml")
  # yamls        = { for file in local.config_files : file => file("../deployments/${var.location_code}/${file}") }
  # merged_yamls = merge(local.yamls)
}
