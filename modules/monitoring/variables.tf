variable "location" {
  description = "The location of resources"
  type        = string
}

variable "network_watcher_name" {
  description = "The network watcher name"
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "The storage account id for log persistence"
  type        = string
  default     = null
}

variable "nsg_keys" {
  description = "The list of nsg keys that are known before apply time."
  type        = any
}

variable "nsgs" {
  description = "The NSGs outputs that are created"
  type = map(object({
    id                  = string
    location            = string
    name                = string
    resource_group_name = string

  }))

  default = {}
}

variable "spoke" {
  description = "The spoke for network fatcher diagnosting settings"
  type        = any
}

variable "log_analytics_workspace" {
  description = ""
  type = object({
    id          = string
    resource_id = string
    location    = string
  })
}

variable "log_analytics_destination_type" {
  type    = string
  default = null
}
