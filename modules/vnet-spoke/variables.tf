variable "spoke" {
  description = "Vnet spoke configuration"
  type = object({
    name                        = string
    legacy_name                 = string
    virtual_hub_name            = string
    virtual_hub_connection_name = string
    resource_group = object({
      name        = string
      legacy_name = string
      location    = string
      tags        = map(string)
    })
    address_space           = list(string)
    tags                    = map(string)
    location                = string
    bgp_community           = string
    dns_servers             = list(string)
    edge_zone               = string
    flow_timeout_in_minutes = string
    subnets = list(object({
      name                                      = string
      address_prefixes                          = list(string)
      service_endpoints                         = list(any)
      service_endpoint_policy_ids               = list(string)
      private_endpoint_network_policies_enabled = bool
      # for App Gateway
      delegation = object({
        name = string
      })
    }))
  })
}

variable "virtual_hub_id" {
  description = "Resource ID of the virtual hub to connect to spoke to."
  type        = string
}
