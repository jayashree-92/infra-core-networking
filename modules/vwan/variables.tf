variable "vwan" {
  description = "Virtual WAN properties"
  type = object({
    name                              = string
    legacy_name                       = string
    subscription_id                   = string
    location                          = string
    disable_vpn_encryption            = bool
    allow_branch_to_branch_traffic    = bool
    office365_local_breakout_category = string
    type                              = string
    tags                              = map(string)
    resource_group = object({
      name        = string
      legacy_name = string
      location    = string
      tags        = map(string)
    })
  })
}
