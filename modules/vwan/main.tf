resource "random_string" "rg_rid" {
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "random_string" "vwan_rid" {
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(try(var.vwan.resource_group.legacy_name, ""), "${var.vwan.resource_group.name}-${random_string.rg_rid.result}")
  location = var.vwan.resource_group.location

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_wan" "vwan" {
  name                              = coalesce(try(var.vwan.legacy_name, ""), "${var.vwan.name}-${random_string.vwan_rid.result}")
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = azurerm_resource_group.rg.location
  disable_vpn_encryption            = var.vwan.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.vwan.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.vwan.office365_local_breakout_category
  type                              = var.vwan.type
  tags                              = var.vwan.tags

  lifecycle {
    prevent_destroy = true
  }
}
