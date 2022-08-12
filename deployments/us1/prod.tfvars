environment_code                   = "prod"
environment_code_short             = "p"
location_code                      = "usc"
location                           = "Central US"

# Spoke Codes
environment_spoke_pprod_code       = "preprod"
environment_spoke_code_pprod_short = "pprod"

virtual_hub_id = "/subscriptions/75641de5-1456-4853-bc77-dd7db76c35a1/resourceGroups/Rg-vWan-Prod-01/providers/Microsoft.Network/virtualHubs/HubNet-Prod-UsC-01"

dns_servers = [
  "10.60.48.4",
  "10.60.48.5",
  "10.70.48.4",
  "10.70.48.5",
  "10.33.4.21",
  "10.33.4.22",
]

vnet_config_map = {
  vnet-spoke-devops-01 = {
    subscription_id_hub   = "75641de5-1456-4853-bc77-dd7db76c35a1"
    subscription_id_spoke = "5a1019fa-917d-4ca0-8580-52ff2469e621"
    spoke_vnet_name       = "devops"
    suffix_number         = "01"
    vnet_address_space    = ["10.60.128.0/23"]
    subnets = {
      main_subnet = {
        subnet_name           = "main"
        subnet_address_prefix = ["10.60.128.0/24"]
      }
    }
  }
  vnet-spoke-platform-pprod-01 = {
    subscription_id_hub   = "75641de5-1456-4853-bc77-dd7db76c35a1"
    subscription_id_spoke = "e4eb0487-0872-4b0f-9185-79cf4d6a2af1"
    spoke_vnet_name       = "platform"
    suffix_number         = "01"
    vnet_address_space    = ["10.60.32.0/20"]
    subnets = {
      dmz_subnet = {
        subnet_name           = "dmz"
        subnet_address_prefix = ["10.60.32.0/24"]
      }
      web_subnet = {
        subnet_name           = "web"
        subnet_address_prefix = ["10.60.33.0/24"]
      }
      int_subnet = {
        subnet_name           = "int"
        subnet_address_prefix = ["10.60.34.0/24"]
      }
      data_subnet = {
        subnet_name           = "data"
        subnet_address_prefix = ["10.60.38.0/24"]
      }
    }
  }
  vnet-spoke-platform-appgw-pprod-01 = {
    subscription_id_hub   = "75641de5-1456-4853-bc77-dd7db76c35a1"
    subscription_id_spoke = "e4eb0487-0872-4b0f-9185-79cf4d6a2af1"
    spoke_vnet_name       = "platform-agw"
    suffix_number         = "01"
    vnet_address_space    = ["10.60.4.0/24"]
    subnets = {
      appgw_subnet = {
        subnet_name           = "appgw"
        subnet_address_prefix = ["10.60.4.0/27"]
      }
      lb_subnet = {
        subnet_name           = "lb"
        subnet_address_prefix = ["10.60.4.32/27"]
      }

    }
  }

}
