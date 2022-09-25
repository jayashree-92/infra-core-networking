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

resource "azurerm_resource_group" "rg_fwp" {
  name     = coalesce(try(var.hub.firewall_policy.resource_group.legacy_name, ""), var.hub.firewall_policy.resource_group.name)
  location = var.hub.firewall_policy.resource_group.location
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall-policy
resource "azurerm_firewall_policy" "fwp" {
  name                = coalesce(try(var.hub.firewall_policy.legacy_name, ""), var.hub.firewall_policy.name)
  resource_group_name = azurerm_resource_group.rg_fwp.name
  location            = coalesce(try(var.hub.firewall_policy.location, ""), azurerm_resource_group.rg_fwp.location)
  tags                = var.hub.firewall_policy.tags
  private_ip_ranges   = var.hub.firewall_policy.private_ip_ranges
  dns {
    proxy_enabled = var.hub.firewall_policy.dns.proxy_enabled
    servers       = var.hub.firewall_policy.dns.servers
  }

  intrusion_detection {
    mode = var.hub.firewall_policy.intrusion_detection.mode
  }

  threat_intelligence_allowlist {
    fqdns        = var.hub.firewall_policy.threat_intelligence_allowlist.fqdns
    ip_addresses = var.hub.firewall_policy.threat_intelligence_allowlist.ip_addresses
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
  location            = coalesce(try(each.value.location, ""), var.hub.location)
  resource_group_name = var.vwan.rg_name
  virtual_wan_id      = var.vwan.id
  address_cidrs       = each.value.address_cidrs
  device_vendor       = each.value.device_vendor
  tags                = each.value.tags

  o365_policy {
    traffic_category {
      allow_endpoint_enabled    = each.value.o365_policy.traffic_category.allow_endpoint_enabled
      default_endpoint_enabled  = each.value.o365_policy.traffic_category.default_endpoint_enabled
      optimize_endpoint_enabled = each.value.o365_policy.traffic_category.optimize_endpoint_enabled
    }
  }
  dynamic "link" {
    for_each = { for link in each.value.links : link.name => link }

    content {
      name          = link.value.name
      fqdn          = link.value.fqdn
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps
      ip_address    = link.value.ip_address

      bgp {
        asn             = link.value.bgp.asn
        peering_address = link.value.bgp.peering_address
      }
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpngc" {
  for_each           = { for site in var.hub.vpn.sites : site.name => site }
  name               = "Connection-${each.value.name}"
  vpn_gateway_id     = azurerm_vpn_gateway.vpng.id
  remote_vpn_site_id = azurerm_vpn_site.vpn-sites[each.value.name].id

  routing {
    associated_route_table = each.value.routing.associated_route_table

    propagated_route_table {
      labels          = each.value.routing.propagated_route_table.labels
      route_table_ids = each.value.routing.propagated_route_table.route_table_ids
    }
  }

  dynamic "vpn_link" {
    for_each = { for link in each.value.links : link.name => link }
    content {
      name                 = vpn_link.value.name
      vpn_site_link_id     = azurerm_vpn_site.vpn-sites[each.value.name].link[index(azurerm_vpn_site.vpn-sites[each.value.name].link.*.name, vpn_link.value.name)].id
      bgp_enabled          = vpn_link.value.connection.bgp_enabled
      egress_nat_rule_ids  = vpn_link.value.connection.egress_nat_rule_ids
      ingress_nat_rule_ids = vpn_link.value.connection.ingress_nat_rule_ids
      shared_key           = vpn_link.value.connection.shared_key

      ipsec_policy {
        dh_group                 = vpn_link.value.connection.ipsec_policy.dh_group
        encryption_algorithm     = vpn_link.value.connection.ipsec_policy.encryption_algorithm
        ike_encryption_algorithm = vpn_link.value.connection.ipsec_policy.ike_encryption_algorithm
        ike_integrity_algorithm  = vpn_link.value.connection.ipsec_policy.ike_integrity_algorithm
        integrity_algorithm      = vpn_link.value.connection.ipsec_policy.integrity_algorithm
        pfs_group                = vpn_link.value.connection.ipsec_policy.pfs_group
        sa_data_size_kb          = vpn_link.value.connection.ipsec_policy.sa_data_size_kb
        sa_lifetime_sec          = vpn_link.value.connection.ipsec_policy.sa_lifetime_sec
      }
    }
  }
}
