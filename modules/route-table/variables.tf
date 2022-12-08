variable "location" {
  description = "The location of resources"
  type        = string
}

variable "rg_name" {
  description = "The name of UDR tables resource group"
  type        = string
}

variable "routes" {
  description = "A list of route definitions"
  # type = list(
  #   object({
  #     name   = string
  #     routes = list(any)
  #     # list(object({
  #     #   # (Required) The name of the route.
  #     #   name = string
  #     #   #  (Required) The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format.
  #     #   address_prefix = string
  #     #   # (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None
  #     #   next_hope_type = string
  #     #   # (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance
  #     #   next_hop_in_ip_address = string
  #     # }))
  #   })
  # )
}
