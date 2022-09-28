terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.24.0"
      configuration_aliases = [
        azurerm.hub,
        azurerm.spoke
      ]
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
