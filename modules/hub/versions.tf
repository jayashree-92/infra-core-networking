terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.16.0"
      configuration_aliases = [
        azurerm.hub
      ]
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
