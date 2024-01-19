locals {
  config_file              = yamldecode(file("../deployments/${var.location_code}/configs.yaml"))
  location_code            = local.config_file.location_code
  subscriptions            = local.config_file.subscriptions
  vwan_subscription        = try({ for i, sub in local.subscriptions : i => sub if(try(sub.contains_vwan, false) == true) }[0], null)
  create_vwan              = try({ for i, sub in local.subscriptions : i => sub if(try(sub.vwan, false) != false) }[0], null) != null
  create_private_dns_zones = try({ for i, sub in local.subscriptions : i => sub if(try(sub.private_dns_zones, false) != false) }[0], null) != null
  subscription_ids         = { for sub in local.subscriptions : sub.name => sub.id }
  subscription_names = {
    sb_net_prod    = "sb-net-prod-01"
    sb_pfm_prod    = "sb-pfm-prod-1a4d"
    sb_pfm_tst     = "sb-pfm-tst-1a4d"
    sb_pfm_qa      = "sb-pfm-qa-1a4d"
    sb_pfm_dev     = "sb-pfm-dev-1a4d"
    sb_id_prod     = "sb-Id-prod-1a4d"
    sb_itt_prod    = "sb-itt-prod-1a4d"
    sb_dvp_prod    = "sb-dvp-prod-1a4d"
    sb_itm_prod    = "sb-itm-prod-1a4d"
    sb_sec_prod    = "sb-sec-prod-01"
    sb_cpo_prod_us = "sb-cpo-prod-us-1a4d"
    sb_cpo_prod_ci = "sb-cpo-prod-ci-1a4d"
    sb_inno_mtl    = "sb-inno-mtl"
  }

  subscriptions_map = {
    sb_net_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_net_prod)]
    sb_pfm_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_prod)]
    sb_pfm_tst     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_tst)]
    sb_pfm_qa      = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_qa)]
    sb_pfm_dev     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_pfm_dev)]
    sb_id_prod     = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_id_prod)]
    sb_itt_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_itt_prod)]
    sb_dvp_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_dvp_prod)]
    sb_itm_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_itm_prod)]
    sb_sec_prod    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_sec_prod)]
    sb_cpo_prod_us = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_cpo_prod_us)]
    sb_cpo_prod_ci = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_cpo_prod_ci)]
    sb_inno_mtl    = local.subscriptions[index(local.subscriptions.*.name, local.subscription_names.sb_inno_mtl)]
  }

  spokes = {
    sb_net_prod    = local.subscriptions_map.sb_net_prod.spokes
    sb_pfm_prod    = local.subscriptions_map.sb_pfm_prod.spokes
    sb_pfm_tst     = local.subscriptions_map.sb_pfm_tst.spokes
    sb_pfm_qa      = local.subscriptions_map.sb_pfm_qa.spokes
    sb_pfm_dev     = local.subscriptions_map.sb_pfm_dev.spokes
    sb_id_prod     = local.subscriptions_map.sb_id_prod.spokes
    sb_itt_prod    = local.subscriptions_map.sb_itt_prod.spokes
    sb_dvp_prod    = local.subscriptions_map.sb_dvp_prod.spokes
    sb_itm_prod    = local.subscriptions_map.sb_itm_prod.spokes
    sb_sec_prod    = local.subscriptions_map.sb_sec_prod.spokes
    sb_cpo_prod_us = local.subscriptions_map.sb_cpo_prod_us.spokes
    sb_cpo_prod_ci = local.subscriptions_map.sb_cpo_prod_ci.spokes
    sb_inno_mtl    = local.subscriptions_map.sb_inno_mtl.spokes
  }

  route_tables = {
    sb_net_prod    = local.subscriptions_map.sb_net_prod.route_tables
    sb_pfm_prod    = local.subscriptions_map.sb_pfm_prod.route_tables
    sb_pfm_tst     = local.subscriptions_map.sb_pfm_tst.route_tables
    sb_pfm_qa      = local.subscriptions_map.sb_pfm_qa.route_tables
    sb_pfm_dev     = local.subscriptions_map.sb_pfm_dev.route_tables
    sb_id_prod     = local.subscriptions_map.sb_id_prod.route_tables
    sb_itt_prod    = local.subscriptions_map.sb_itt_prod.route_tables
    sb_dvp_prod    = local.subscriptions_map.sb_dvp_prod.route_tables
    sb_itm_prod    = local.subscriptions_map.sb_itm_prod.route_tables
    sb_sec_prod    = local.subscriptions_map.sb_sec_prod.route_tables
    sb_cpo_prod_us = local.subscriptions_map.sb_cpo_prod_us.route_tables
    sb_cpo_prod_ci = local.subscriptions_map.sb_cpo_prod_ci.route_tables
    sb_inno_mtl    = local.subscriptions_map.sb_inno_mtl.route_tables
  }


  sb_rid_keys = [for sb_name in local.subscription_names : sb_name]

  fw_diag_settings_categories = [
    "AZFWApplicationRule",
    "AZFWApplicationRuleAggregation",
    "AZFWDnsQuery",
    "AZFWFatFlow",
    "AZFWFlowTrace",
    "AZFWFqdnResolveFailure",
    "AZFWIdpsSignature",
    "AZFWNatRule",
    "AZFWNatRuleAggregation",
    "AZFWNetworkRule",
    "AZFWNetworkRuleAggregation",
    "AZFWThreatIntel",
  ]
}
