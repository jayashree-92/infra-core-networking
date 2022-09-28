provider "azurerm" {
  alias           = "vwan_hubs"
  subscription_id = local.vwan_subscription.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_prod_01"
  subscription_id = local.subscription_ids["sb-pfm-prod-01"]
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_stg_01"
  subscription_id = local.subscription_ids["sb-pfm-stg-01"]
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_qa_01"
  subscription_id = local.subscription_ids["sb-pfm-qa-01"]
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_dev_01"
  subscription_id = local.subscription_ids["sb-pfm-dev-01"]
  features {
  }
}



# provider "azurerm" {
#   alias           = "sbclientprodus01"
#   subscription_id = "b69669b9-6d12-4ada-b44d-5f578b85f46c"
#   features {
#   }
# }

# provider "azurerm" {
#   alias           = "sbclientdevus01"
#   subscription_id = "4172118f-0fbf-4130-ba5b-5ad78292ae91"
#   features {
#   }
# }

provider "azurerm" {
  features {}
}
