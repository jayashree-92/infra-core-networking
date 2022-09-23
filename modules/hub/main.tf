terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.16.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

resource "azurerm_virtual_hub" "hub" {
  name                = coalesce(try(var.hub.legacy_name, ""), var.hub.name)
  resource_group_name = var.vwan.rg_name
  location            = var.hub.location
  virtual_wan_id      = var.vwan.id
  address_prefix      = var.hub.address_prefix #The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23
  sku                 = var.hub.sku
}

resource "azurerm_virtual_hub_route_table" "vhrt" {
  for_each       = { for route_table in var.hub.route_tables : route_table.name => route_table }
  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.hub.id
  labels         = each.value.labels

  dynamic "route" {
    for_each = { for route in each.value.routes : route.name => route }
    content {
      name              = route.value.name
      destinations_type = route.value.destinations_type
      destinations      = route.value.destinations
      next_hop_type     = route.value.next_hop_type
      next_hop          = route.value.next_hop
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall-policy
resource "azurerm_firewall_policy" "fwp" {
  name                = coalesce(try(var.hub.firewall_policy.legacy_name, ""), var.hub.firewall_policy.name)
  resource_group_name = var.vwan.rg_name
  location            = var.hub.location
  tags                = var.hub.firewall_policy.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
resource "azurerm_firewall" "fw" {
  name                = coalesce(try(var.hub.firewall.legacy_name, ""), var.hub.firewall.name)
  location            = var.hub.location
  resource_group_name = var.vwan.rg_name
  sku_name            = var.hub.firewall.sku_name
  sku_tier            = var.hub.firewall.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.fwp.id
  tags                = var.hub.firewall.tags

  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.hub.id
  }
}

resource "azurerm_vpn_gateway" "vpng" {
  name                = var.hub.vpn.gateway_name
  location            = var.hub.location
  resource_group_name = var.vwan.rg_name
  virtual_hub_id      = azurerm_virtual_hub.hub.id
}

resource "azurerm_vpn_site" "vpn-sites" {
  for_each            = { for site in var.hub.vpn.sites : site.name => site }
  name                = each.value.name
  location            = var.hub.location
  resource_group_name = var.vwan.rg_name
  virtual_wan_id      = var.vwan.id

  dynamic "link" {
    for_each = { for link in each.value.links : link.name => link }
    content {
      name       = link.value.name
      ip_address = link.value.ip_address
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpngc" {
  for_each           = { for site in var.hub.vpn.sites : site.name => site }
  name               = "${each.value.name}-vpn-gateway-connection"
  vpn_gateway_id     = azurerm_vpn_gateway.vpng.id
  remote_vpn_site_id = azurerm_vpn_site.vpn-sites[each.value.name].id

  dynamic "vpn_link" {
    for_each = { for link in each.value.links : link.name => link }
    content {
      name             = vpn_link.value.name
      vpn_site_link_id = azurerm_vpn_site.vpn-sites[each.value.name].link[index(azurerm_vpn_site.vpn-sites[each.value.name].link.*.name, vpn_link.value.name)].id
    }
  }
}
