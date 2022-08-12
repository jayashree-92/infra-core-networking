variable "environment_code" {
  description = "Environment code"
}

variable "environment_code_short" {
  description = "Environment code short for resource naming limitations"
}

variable "location_code" {
  description = "Location code"
}

variable "location" {
  description = "Location in which to deploy resources"
}

variable "subnet" {
  description = "List of subnets to deploy for the spoke vnet"
  type        = map(any)
  default     = {}
}

variable "dns_servers" {
  description = "Name server IP list"
  type        = list(any)
  default     = []
}

variable "virtual_hub_id" {
  description = "Resource ID of the virtual hub"
  default     = ""
}

variable "vnet_config_map" {
  description = "Configuration map for the virtual networks"
  type        = map(any)
  default     = {}
}

variable "environment_spoke_pprod_code" {

}

variable "environment_spoke_code_pprod_short" {

}
