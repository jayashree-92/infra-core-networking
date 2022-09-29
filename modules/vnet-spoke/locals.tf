locals {
  rg_vnet_key = "rg_vnet"
  vnet_key    = "vnet"
  vhc_key     = "vhc"
  rg_nsg_key  = "rg_nsg"
  snet_keys   = var.spoke.subnets[*].name
  nsg_keys    = var.spoke.subnets[*].nsg_name
  rid_keys    = concat([local.rg_vnet_key, local.vnet_key, local.vhc_key, local.rg_nsg_key], local.snet_keys, local.nsg_keys)
}
