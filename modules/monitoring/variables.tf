variable "location" {
  description = "The location of resources"
  type        = string
}

variable "network_watcher_name" {
  description = "The network watcher name"
  type        = string
}

variable "storage_account_id" {
  description = "The storage account id for log persistence"
  type        = string
}

variable "nsgs" {
  description = "The resource group name for network watcher flow log resources where its related nsg are"
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
