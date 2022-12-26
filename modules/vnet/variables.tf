variable "location" {
  description = "The location of resources"
  type        = string
}

variable "vnet" {
  description = "Vnet spoke configuration"
  type = object({
    name     = string
    function = string
    resource_group = object({
      name     = string
      location = string
      tags     = map(string)
    })
    address_space = list(string)
    tags          = map(string)
    location      = string
    dns_servers   = list(string)
    subnets = list(object({
      name             = string
      address_prefixes = list(string)
    }))
  })
}
