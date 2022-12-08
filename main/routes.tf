module "routes_pfm_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_prod.routes_rg_name
  routes   = local.route_tables.sb_pfm_prod

  providers = {
    azurerm = azurerm.sb_pfm_prod_01
  }
}

output "route_test" {
  value = module.routes_pfm_prod
}

module "routes_pfm_stg" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_stg.routes_rg_name
  routes   = local.route_tables.sb_pfm_stg

  providers = {
    azurerm = azurerm.sb_pfm_stg_01
  }
}

module "routes_pfm_qa" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_qa.routes_rg_name
  routes   = local.route_tables.sb_pfm_qa

  providers = {
    azurerm = azurerm.sb_pfm_qa_01
  }
}

module "routes_pfm_dev" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_pfm_dev.routes_rg_name
  routes   = local.route_tables.sb_pfm_dev

  providers = {
    azurerm = azurerm.sb_pfm_dev_01
  }
}


module "routes_id_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_id_prod.routes_rg_name
  routes   = local.route_tables.sb_id_prod

  providers = {
    azurerm = azurerm.sb_id_prod
  }
}

module "routes_itt_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_itt_prod.routes_rg_name
  routes   = local.route_tables.sb_itt_prod

  providers = {
    azurerm = azurerm.sb_itt_prod
  }
}

module "routes_dvp_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_dvp_prod.routes_rg_name
  routes   = local.route_tables.sb_dvp_prod

  providers = {
    azurerm = azurerm.sb_dvp_prod
  }
}

module "routes_itm_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_itm_prod.routes_rg_name
  routes   = local.route_tables.sb_itm_prod

  providers = {
    azurerm = azurerm.sb_itm_prod
  }
}

module "routes_sec_prod" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_sec_prod.routes_rg_name
  routes   = local.route_tables.sb_sec_prod

  providers = {
    azurerm = azurerm.sb_sec_prod
  }
}

module "routes_cpo_prod_us" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_cpo_prod_us.routes_rg_name
  routes   = local.route_tables.sb_cpo_prod_us

  providers = {
    azurerm = azurerm.sb_cpo_prod_us
  }
}

module "routes_cpo_prod_ci" {
  source   = "../modules/route-table"
  location = local.config_file.location
  rg_name  = local.subscriptions_map.sb_cpo_prod_ci.routes_rg_name
  routes   = local.route_tables.sb_cpo_prod_ci

  providers = {
    azurerm = azurerm.sb_cpo_prod_ci
  }
}
