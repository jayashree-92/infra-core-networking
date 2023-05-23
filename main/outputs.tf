output "vwan" {
  value = {
    id      = local.create_vwan == true ? module.vwan[0].vwan_id : null
    rg_name = local.create_vwan == true ? module.vwan[0].vwan_rg_name : null
  }
}

output "private_dns_zones" {
  value = local.create_private_dns_zones == true ? module.private_dns_zones[0] : null
}

output "hub" {
  value = module.hubs
}

output "vnet_spokes" {
  value = {
    "${local.subscription_names.sb_pfm_prod}" = module.spokes_sb_pfm_prod
  }
}

output "nsg_nsr_map" {
  value = {
    "${var.location_code}" = {
      "prod" = merge(
        { for item in keys(module.spokes_sb_pfm_prod) : keys(module.spokes_sb_pfm_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_pfm_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_id_prod) : keys(module.spokes_sb_id_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_id_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_itt_prod) : keys(module.spokes_sb_itt_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_itt_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_dvp_prod) : keys(module.spokes_sb_dvp_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_dvp_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_itm_prod) : keys(module.spokes_sb_itm_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_itm_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_sec_prod) : keys(module.spokes_sb_sec_prod[item].nsg_nsr_map)[0] => values(module.spokes_sb_sec_prod[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_cpo_prod_us) : keys(module.spokes_sb_cpo_prod_us[item].nsg_nsr_map)[0] => values(module.spokes_sb_cpo_prod_us[item].nsg_nsr_map)[0]... },
        { for item in keys(module.spokes_sb_cpo_prod_ci) : keys(module.spokes_sb_cpo_prod_ci[item].nsg_nsr_map)[0] => values(module.spokes_sb_cpo_prod_ci[item].nsg_nsr_map)[0]... },
      )
      "dev" = { for item in keys(module.spokes_sb_pfm_dev) : keys(module.spokes_sb_pfm_dev[item].nsg_nsr_map)[0] => values(module.spokes_sb_pfm_dev[item].nsg_nsr_map)[0]... }
      "qa"  = { for item in keys(module.spokes_sb_pfm_qa) : keys(module.spokes_sb_pfm_qa[item].nsg_nsr_map)[0] => values(module.spokes_sb_pfm_qa[item].nsg_nsr_map)[0]... }
      "stg" = { for item in keys(module.spokes_sb_pfm_tst) : keys(module.spokes_sb_pfm_tst[item].nsg_nsr_map)[0] => values(module.spokes_sb_pfm_tst[item].nsg_nsr_map)[0]... }
    }
  }
}

output "create_vwan" {
  value = local.create_vwan
}

output "rmt_state" {
  value = local.create_vwan == true ? null : try(data.terraform_remote_state.vwan[0].outputs, null)
}
