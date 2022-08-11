locals {
  full_env_code  = format("%s-%s", var.environment_code, var.location_code)
  short_env_code = format("%s-%s", var.environment_code_short, var.location_code)

  full_env_pprod_code  = format("%s-%s", var.environment_pprod_code, var.location_code)
  short_env_pprod_code = format("%s-%s", var.environment_code_pprod_short, var.location_code)


  dep_generic_map = {
    full_env_code  = local.full_env_code
    short_env_code = local.short_env_code
    location       = var.location
  }
  dep_pprod_map = {
    full_env_code  = local.full_env_pprod_code
    short_env_code = local.short_env_pprod_code
    location       = var.location
  }
}
