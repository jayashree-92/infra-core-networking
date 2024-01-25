provider "azurerm" {
  alias           = "sb_net_prod"
  subscription_id = local.vwan_subscription.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }

}

provider "azurerm" {
  alias           = "sb_pfm_prod_01"
  subscription_id = local.subscriptions_map.sb_pfm_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_pfm_stg_01"
  subscription_id = local.subscriptions_map.sb_pfm_tst.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_pfm_qa_01"
  subscription_id = local.subscriptions_map.sb_pfm_qa.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_pfm_dev_01"
  subscription_id = local.subscriptions_map.sb_pfm_dev.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_id_prod"
  subscription_id = local.subscriptions_map.sb_id_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_itt_prod"
  subscription_id = local.subscriptions_map.sb_itt_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_dvp_prod"
  subscription_id = local.subscriptions_map.sb_dvp_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_itm_prod"
  subscription_id = local.subscriptions_map.sb_itm_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_sec_prod"
  subscription_id = local.subscriptions_map.sb_sec_prod.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_keys_on_destroy    = false
      purge_soft_deleted_secrets_on_destroy = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_cpo_prod_us"
  subscription_id = local.subscriptions_map.sb_cpo_prod_us.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_cpo_prod_ci"
  subscription_id = local.subscriptions_map.sb_cpo_prod_ci.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  alias           = "sb_inno_mtl"
  subscription_id = local.subscriptions_map.sb_inno_mtl.id
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
}
