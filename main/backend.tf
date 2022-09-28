terraform {
  backend "azurerm" {
  }
}

data "terraform_remote_state" "vwan" {
  count   = local.create_vwan ? 0 : 1
  backend = "azurerm"
  config = {
    storage_account_name = "terraformf157063802"
    container_name       = "tfstate"
    key                  = "${local.vwan_subscription.id}.networking.terraform.tfstate"
    access_key           = var.terraform_remote_state_access_key
    subscription_id      = local.vwan_subscription.id
  }
}
