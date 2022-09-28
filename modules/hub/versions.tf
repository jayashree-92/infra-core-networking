terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.24.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}