environment_code       = "prod"
environment_code_short = "p"
location_code          = "usc"
location               = "Central US"

virtual_hub_id = "/subscriptions/75641de5-1456-4853-bc77-dd7db76c35a1/resourceGroups/Rg-vWan-Prod-01/providers/Microsoft.Network/virtualHubs/HubNet-Prod-UsC-01"

dns_servers = [
  "10.33.4.21",
  "10.33.4.22",
  "10.60.48.4",
  "10.60.48.5",
  "10.70.48.4",
  "10.70.48.5"
]

vnet_config_map = {
  vnet-spoke-devops-01 = {
    subscription_id_hub   = "75641de5-1456-4853-bc77-dd7db76c35a1"
    subscription_id_spoke = "5a1019fa-917d-4ca0-8580-52ff2469e621"
    spoke_vnet_name    = "devops"
    suffix_number      = "01"
    vnet_address_space = ["10.60.128.0/23"]
    subnets = {
      main_subnet = {
        subnet_name           = "main"
        subnet_address_prefix = ["10.60.128.0/24"]
      }
    }
  }
}
