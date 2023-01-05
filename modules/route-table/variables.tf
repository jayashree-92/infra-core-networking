variable "location" {
  description = "The location of resources"
  type        = string
}

variable "rg_name" {
  description = "The name of UDR tables resource group"
  type        = string
}

variable "routes" {
  description = "A list of route table definitions"
  type = list(
    object({
      name                          = string
      disable_bgp_route_propagation = bool
      routes = optional(list(object({
        name                   = string
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = string
      })))
    })
  )
}
