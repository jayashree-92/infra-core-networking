resource "random_string" "nsg_rg_rids" {
  for_each    = toset(local.sb_rid_keys)
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_resource_group" "rg_nsg_prod" {
  provider = azurerm.sb_pfm_prod_01
  name     = "${local.subscriptions_map.sb_pfm_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_tst" {
  provider = azurerm.sb_pfm_stg_01
  name     = "${local.subscriptions_map.sb_pfm_tst.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_tst].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_qa" {
  provider = azurerm.sb_pfm_qa_01
  name     = "${local.subscriptions_map.sb_pfm_qa.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_qa].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_dev" {
  provider = azurerm.sb_pfm_dev_01
  name     = "${local.subscriptions_map.sb_pfm_dev.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_pfm_dev].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_id_prod" {
  provider = azurerm.sb_id_prod
  name     = "${local.subscriptions_map.sb_id_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_id_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_itt_prod" {
  provider = azurerm.sb_itt_prod
  name     = "${local.subscriptions_map.sb_itt_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_itt_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_dvp_prod" {
  provider = azurerm.sb_dvp_prod
  name     = "${local.subscriptions_map.sb_dvp_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_dvp_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_itm_prod" {
  provider = azurerm.sb_itm_prod
  name     = "${local.subscriptions_map.sb_itm_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_itm_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_sec_prod" {
  provider = azurerm.sb_sec_prod
  name     = "${local.subscriptions_map.sb_sec_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_sec_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_net_prod" {
  provider = azurerm.sb_net_prod
  name     = "${local.subscriptions_map.sb_net_prod.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_net_prod].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_cpo_prod_us" {
  provider = azurerm.sb_cpo_prod_us
  name     = "${local.subscriptions_map.sb_cpo_prod_us.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_cpo_prod_us].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_cpo_prod_ci" {
  provider = azurerm.sb_cpo_prod_ci
  name     = "${local.subscriptions_map.sb_cpo_prod_ci.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_cpo_prod_ci].result}"
  location = local.config_file.location
}

resource "azurerm_resource_group" "rg_nsg_sb_inno_mtl" {
  provider = azurerm.sb_inno_mtl
  name     = "${local.subscriptions_map.sb_inno_mtl.nsg_rg_name}-${random_string.nsg_rg_rids[local.subscription_names.sb_inno_mtl].result}"
  location = local.config_file.location
}
