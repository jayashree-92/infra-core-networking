provider "azurerm" {
  alias           = "vwan_hubs"
  subscription_id = local.vwan_subscription.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_prod_01"
  subscription_id = local.subscriptions_map.sb_pfm_prod.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_stg_01"
  subscription_id = local.subscriptions_map.sb_pfm_stg.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_qa_01"
  subscription_id = local.subscriptions_map.sb_pfm_qa.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_dev_01"
  subscription_id = local.subscriptions_map.sb_pfm_dev.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_id_prod"
  subscription_id = local.subscriptions_map.sb_id_prod.id
  features {
  }
}

provider "azurerm" {
  features {}
}
