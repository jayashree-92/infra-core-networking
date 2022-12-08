provider "azurerm" {
  alias           = "sb_net_prod"
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
  alias           = "sb_itt_prod"
  subscription_id = local.subscriptions_map.sb_itt_prod.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_dvp_prod"
  subscription_id = local.subscriptions_map.sb_dvp_prod.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_itm_prod"
  subscription_id = local.subscriptions_map.sb_itm_prod.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_sec_prod"
  subscription_id = local.subscriptions_map.sb_sec_prod.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_cpo_prod_us"
  subscription_id = local.subscriptions_map.sb_cpo_prod_us.id
  features {
  }
}

provider "azurerm" {
  alias           = "sb_cpo_prod_ci"
  subscription_id = local.subscriptions_map.sb_cpo_prod_ci.id
  features {
  }
}

provider "azurerm" {
  features {}
}
