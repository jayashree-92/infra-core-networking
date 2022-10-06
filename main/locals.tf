locals {
  config_file       = yamldecode(file("../deployments/${var.location_code}/configs.yaml"))
  location_code     = local.config_file.location_code
  subscriptions     = local.config_file.subscriptions
  vwan_subscription = try({ for i, sub in local.subscriptions : i => sub if(try(sub.contains_vwan, false) == true) }[0], null)
  create_vwan       = try({ for i, sub in local.subscriptions : i => sub if(try(sub.vwan, false) != false) }[0], null) != null
  subscription_ids  = { for sub in local.subscriptions : sub.name => sub.id }
  subscription_names = {
    sb_pfm_prod    = "sb-pfm-prod-1a4d"
    sb_pfm_stg     = "sb-pfm-stg-01"
    sb_pfm_qa      = "sb-pfm-qa-1a4d"
    sb_pfm_dev     = "sb-pfm-dev-1a4d"
    sb_id_prod     = "sb-Id-prod-1a4d"
    sb_itt_prod    = "sb-itt-prod-1a4d"
    sb_dvp_prod    = "sb-dvp-prod-1a4d"
    sb_itm_prod    = "sb-itm-prod-1a4d"
    sb_sec_prod    = "sb-sec-prod-01"
    sb_cpo_prod_us = "sb-cpo-prod-us-1a4d"
    sb_cpo_prod_ci = "sb-cpo-prod-ci-1a4d"
  }

  subscriptions_map = {
    sb_pfm_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_prod)]
    sb_pfm_stg     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_stg)]
    sb_pfm_qa      = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_qa)]
    sb_pfm_dev     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_dev)]
    sb_id_prod     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_id_prod)]
    sb_itt_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_itt_prod)]
    sb_dvp_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_dvp_prod)]
    sb_itm_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_itm_prod)]
    sb_sec_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_sec_prod)]
    sb_cpo_prod_us = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_cpo_prod_us)]
    sb_cpo_prod_ci = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_cpo_prod_ci)]
  }

  spokes = {
    sb_pfm_prod    = local.subscriptions_map.sb_pfm_prod.spokes
    sb_pfm_stg     = local.subscriptions_map.sb_pfm_stg.spokes
    sb_pfm_qa      = local.subscriptions_map.sb_pfm_qa.spokes
    sb_pfm_dev     = local.subscriptions_map.sb_pfm_dev.spokes
    sb_id_prod     = local.subscriptions_map.sb_id_prod.spokes
    sb_itt_prod    = local.subscriptions_map.sb_itt_prod.spokes
    sb_dvp_prod    = local.subscriptions_map.sb_dvp_prod.spokes
    sb_itm_prod    = local.subscriptions_map.sb_itm_prod.spokes
    sb_sec_prod    = local.subscriptions_map.sb_sec_prod.spokes
    sb_cpo_prod_us = local.subscriptions_map.sb_cpo_prod_us.spokes
    sb_cpo_prod_ci = local.subscriptions_map.sb_cpo_prod_ci.spokes
  }

  sb_rid_keys = [for sb_name in local.subscription_names : sb_name]


  netw_rg_key       = "netw_rg_key"
  sa_key            = "sa_key"
  netw_key          = "netw_key"
  vwan_hub_rid_keys = [local.netw_rg_key, local.sa_key, local.netw_key]

  # config_files = fileset("../deployments/${var.location_code}/", "*configs.yaml")
  # yamls        = { for file in local.config_files : file => file("../deployments/${var.location_code}/${file}") }
  # merged_yamls = merge(local.yamls)
}
