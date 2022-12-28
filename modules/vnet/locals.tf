locals {
  rg_vnet_key = "rg_vnet"
  vnet_key    = "vnet"
  rg_nsg_key  = "rg_nsg"
  nsg_keys    = var.vnet.subnets[*].nsg_name
  snet_keys   = var.vnet.subnets[*].name
  rid_keys    = concat([local.rg_vnet_key, local.vnet_key, local.rg_nsg_key], local.snet_keys, local.nsg_keys)
}
