locals {
  fw_key     = "fw"
  fwp_key    = "fwp"
  rg_fwp_key = "rg_fwp"
  rid_keys   = [local.fw_key, local.fwp_key, local.rg_fwp_key]
}
