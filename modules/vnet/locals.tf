locals {
  rg_vnet_key = "rg_vnet"
  vnet_key    = "vnet"
  snet_keys   = var.vnet.subnets[*].name
  rid_keys    = concat([local.rg_vnet_key, local.vnet_key], local.snet_keys)
}
