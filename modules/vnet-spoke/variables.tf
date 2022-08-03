variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "create_hub_connection" {
  description = "Whether to create the virtual hub connection when deploying a spoke vnet"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "spoke_vnet_name" {
  description = "The name of the spoke virtual network."
  default     = ""
}

variable "is_spoke_deployed_to_same_hub_subscription" {
  description = "Specify the Azure subscription to use to create the resoruces. possible to use diferent Azure subscription for spokes."
  default     = true
}

variable "vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = ["10.1.0.0/16"]
}

variable "create_ddos_plan" {
  description = "Create an ddos plan - Default is false"
  default     = false
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  default     = []
}

variable "subnets" {
  description = "For each subnet, create an object that contain fields"
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "dep_generic_map" {
  type    = map(any)
  default = {}
}

variable "suffix_number" {
  description = "Suffix number to add at the end of the resource name"
  default     = ""
}

variable "virtual_hub_id" {
  description = "Resource ID of the virtual hub"
  default     = ""
}

variable "subscription_id_hub" {
  description = "Subscription ID for the hub"
  default     = ""
}

variable "subscription_id_spoke" {
  description = "Subscription ID for the spoke"
  default     = ""
}
