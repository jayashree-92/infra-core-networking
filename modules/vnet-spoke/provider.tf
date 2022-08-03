provider "azurerm" {
  alias = "hub"
  subscription_id = var.subscription_id_hub
  features {
    
  }
}

provider "azurerm" {
  alias = "spoke"
  subscription_id = var.subscription_id_spoke
  features {
    
  }
}