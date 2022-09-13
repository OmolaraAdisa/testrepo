provider "azurerm" {
  version = "3.0.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name = "rg-function"
    storage_account_name = "larafunction"
    container_name = "cafunction"
    key = "terraform.tfstate"
  }
}