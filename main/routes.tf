module "routes_pfm_prod" {
  count    = length(local.route_tables.sb_pfm_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_prod.routes_rg_name
  routes   = local.route_tables.sb_pfm_prod

  providers = {
    azurerm = azurerm.sb_pfm_prod_01
  }
}

output "route_test" {
  value = length(local.subscriptions_map.sb_pfm_prod.routes_rg_name) > 0 ? module.routes_pfm_prod : null
}

module "routes_pfm_tst" {
  count    = length(local.route_tables.sb_pfm_tst) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_tst.routes_rg_name
  routes   = local.route_tables.sb_pfm_tst

  providers = {
    azurerm = azurerm.sb_pfm_stg_01
  }
}

module "routes_pfm_qa" {
  count    = length(local.route_tables.sb_pfm_qa) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_qa.routes_rg_name
  routes   = local.route_tables.sb_pfm_qa

  providers = {
    azurerm = azurerm.sb_pfm_qa_01
  }
}

module "routes_pfm_dev" {
  count    = length(local.route_tables.sb_pfm_dev) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_dev.routes_rg_name
  routes   = local.route_tables.sb_pfm_dev

  providers = {
    azurerm = azurerm.sb_pfm_dev_01
  }
}


module "routes_id_prod" {
  count    = length(local.route_tables.sb_id_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_id_prod.routes_rg_name
  routes   = local.route_tables.sb_id_prod

  providers = {
    azurerm = azurerm.sb_id_prod
  }
}

module "routes_itt_prod" {
  count    = length(local.route_tables.sb_itt_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_itt_prod.routes_rg_name
  routes   = local.route_tables.sb_itt_prod

  providers = {
    azurerm = azurerm.sb_itt_prod
  }
}

module "routes_dvp_prod" {
  count    = length(local.route_tables.sb_dvp_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_dvp_prod.routes_rg_name
  routes   = local.route_tables.sb_dvp_prod

  providers = {
    azurerm = azurerm.sb_dvp_prod
  }
}

module "routes_itm_prod" {
  count    = length(local.route_tables.sb_itm_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_itm_prod.routes_rg_name
  routes   = local.route_tables.sb_itm_prod

  providers = {
    azurerm = azurerm.sb_itm_prod
  }
}

module "routes_sec_prod" {
  count    = length(local.route_tables.sb_sec_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_sec_prod.routes_rg_name
  routes   = local.route_tables.sb_sec_prod

  providers = {
    azurerm = azurerm.sb_sec_prod
  }
}

module "routes_net_prod" {
  count    = length(local.route_tables.sb_net_prod) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_net_prod.routes_rg_name
  routes   = local.route_tables.sb_net_prod

  providers = {
    azurerm = azurerm.sb_net_prod
  }
}

module "routes_cpo_prod_us" {
  count    = length(local.route_tables.sb_cpo_prod_us) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_cpo_prod_us.routes_rg_name
  routes   = local.route_tables.sb_cpo_prod_us

  providers = {
    azurerm = azurerm.sb_cpo_prod_us
  }
}

module "routes_cpo_prod_ci" {
  count    = length(local.route_tables.sb_cpo_prod_ci) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_cpo_prod_ci.routes_rg_name
  routes   = local.route_tables.sb_cpo_prod_ci

  providers = {
    azurerm = azurerm.sb_cpo_prod_ci
  }
}

module "routes_inno_mtl" {
  count    = length(local.route_tables.sb_inno_mtl) > 0 ? 1 : 0
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_inno_mtl.routes_rg_name
  routes   = local.route_tables.sb_inno_mtl

  providers = {
    azurerm = azurerm.sb_inno_mtl
  }
}
