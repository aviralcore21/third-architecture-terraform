terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.3.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "stracc034acc01"
    resource_group_name  = "rg-dev-app"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"

  }

  required_version = "1.16.3"
}

provider "azurerm" {
  features {
  }
}