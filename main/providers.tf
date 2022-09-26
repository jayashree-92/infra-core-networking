provider "azurerm" {
  alias           = "hub"
  subscription_id = "75641de5-1456-4853-bc77-dd7db76c35a1"
  features {
  }
}

provider "azurerm" {
  alias           = "sb_pfm_qa_uc_01"
  subscription_id = local.subscription_ids.sb_pfm_qa_uc_01
  features {
  }
}

provider "azurerm" {
  alias           = "sbclientprodus01"
  subscription_id = "b69669b9-6d12-4ada-b44d-5f578b85f46c"
  features {
  }
}

provider "azurerm" {
  alias           = "sbclientdevus01"
  subscription_id = "4172118f-0fbf-4130-ba5b-5ad78292ae91"
  features {
  }
}

provider "azurerm" {
  features {}
}
