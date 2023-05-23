terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}


resource "random_string" "rg_rid" {
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}


resource "random_string" "route_rids" {
  for_each    = { for route in var.routes : route.name => route }
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_numeric = 2
  min_lower   = 2
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${random_string.rg_rid.result}"
  location = var.location
}


resource "azurerm_route_table" "route_tables" {
  for_each                      = { for route in var.routes : route.name => route }
  name                          = coalesce(try(each.value.legacy_name, ""), "${each.key}-${random_string.route_rids[each.key].result}")
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags = merge(
    {
      managed-by    = "Terraform"
      resource-name = each.key
    },
    try(each.value.tags, {}),
  try(each.value.legacy_name, "") != "" ? { legacy-name = each.value.legacy_name } : {})

  dynamic "route" {
    for_each = { for route in each.value.routes : route.name => route }
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}
