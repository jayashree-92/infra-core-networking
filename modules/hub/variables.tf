
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
        name = string
        links = list(object({
          name       = string
          ip_address = string
        }))
      }))
    })

    firewall_policy = object({
      name        = string
      legacy_name = string
      tags        = map(string)
    })


    firewall = object({
      name     = string
      sku_tier = string
      sku_name = string
      tags     = map(string)
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
