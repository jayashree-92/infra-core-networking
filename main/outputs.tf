output "vwan" {
  value = {
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : null
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : null
  }
}

output "hub" {
  value = module.hubs
}

output "vnet_spokes" {
  value = {
    "${local.subscription_names.sb_pfm_prod}" = module.spokes_sb_pfm_prod
  }
}

output "create_vwan" {
  value = local.create_vwan
}

output "rmt_state" {
  value = local.create_vwan == true ? null : try(data.terraform_remote_state.vwan[0].outputs, null)
}
