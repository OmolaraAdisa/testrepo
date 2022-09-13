terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name = "rg-function"
    storage_account_name = "larafunction"
    container_name = "cafunction"
    key = "root.terraform.tfstate"
  }
}