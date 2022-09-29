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
    "sb-pfm-prod-1a4d" = module.spokes_sb_pfm_prod
  }
}

# output "config_files" {
#   value = local.config_files
# }

# output "merged_yamls" {
#   value = local.merged_yamls
# }

output "subscription_ids" {
  value = local.subscription_ids
}

# output "subscriptions_map" {
#   value = local.subscriptions_map
# }
output "create_vwan" {
  value = local.create_vwan
}

output "rmt_state" {
  value = local.create_vwan == true ? null : try(data.terraform_remote_state.vwan[0].outputs, null)
}

# output "vwan" {
#   value = module.vwan
# }

# output "hubs" {
#   value = module.hubs
# }

# output "vhub_ud_test" {
#   value = module.hubs["vhub-net-prod-uc-01"].hub.id
# }
