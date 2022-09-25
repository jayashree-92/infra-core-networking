
variable "vwan" {
  description = "Virtual WAN"
  type = object({
    id      = string
    rg_name = string
  })
}

variable "hub" {
  description = "Virtual HUB properties"
  type = object({
    name            = string
    legacy_name     = string
    subscription_id = string
    location        = string
    address_prefix  = string
    sku             = string

    vpn = object({
      gateway_name = string
      sites = list(object({
        name          = string
        location      = string
        address_cidrs = list(string)
        device_vendor = string
        tags          = map(string)
        o365_policy = object({
          traffic_category = object({
            allow_endpoint_enabled    = bool
            default_endpoint_enabled  = bool
            optimize_endpoint_enabled = bool
          })
        })
        routing = object({
          associated_route_table = string
          propagated_route_table = object({
            labels          = list(string)
            route_table_ids = list(string)
          })
        })
        links = list(object({
          name          = string
          fqdn          = string
          provider_name = string
          speed_in_mbps = number
          bgp = object({
            asn             = number
            peering_address = string
          })

          connection = object({
            bgp_enabled          = bool
            egress_nat_rule_ids  = list(string)
            ingress_nat_rule_ids = list(string)
            shared_key           = string
            ipsec_policy = object({
              dh_group                 = string
              encryption_algorithm     = string
              ike_encryption_algorithm = string
              ike_integrity_algorithm  = string
              integrity_algorithm      = string
              pfs_group                = string
              sa_data_size_kb          = number
              sa_lifetime_sec          = number
            })

          })
          ip_address = string
        }))
      }))
    })

    firewall_policy = object({
      name        = string
      legacy_name = string
      tags        = map(string)
      location    = string
      resource_group = object({
        name        = string
        legacy_name = string
        location    = string
        tags        = map(string)
      })
    })


    firewall = object({
      name        = string
      legacy_name = string
      sku_tier    = string
      sku_name    = string
      tags        = map(string)
    })

    route_tables = list(
      object({
        name   = string
        labels = list(string)
        routes = list(
          object({
            name              = string
            destinations_type = string
            destinations      = list(string)
            next_hop_type     = string
            next_hop          = string
        }))
    }))

    tags = map(string)
  })
}
