variable "location" {
  description = "The location of resources"
  type        = string
}

variable "nsg_rg_name" {
  description = "The name of NSG resource group"
  type        = string
}

variable "nsg_rg_location" {
  description = "The location of NSG resource group"
  type        = string
}


variable "spoke" {
  description = "Vnet spoke configuration"
  type = object({
    name                               = string
    legacy_name                        = string
    virtual_hub_name                   = string
    virtual_hub_connection_name        = string
    legacy_virtual_hub_connection_name = string
    function                           = string
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
      legacy_name                               = string
      workload_tier                             = string
      nsg_name                                  = string
      address_prefixes                          = list(string)
      service_endpoints                         = list(any)
      service_endpoint_policy_ids               = list(string)
      private_endpoint_network_policies_enabled = bool
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

variable "virtual_hub_firewall_private_ip_address" {
  description = "Ip adress used as dns server for the spoke"
  type        = string
}

variable "environment" {
  description = "Environment"
  default     = "prod"
}

variable "sb_function" {
  description = "The function of the subscription."
}
