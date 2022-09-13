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
    key = "ZpkNBOdahkW+a1rtxBdbOnFgupAi+P8mjKf+HOttEPqu22W+XJ0KbK+jYg5m8aNhR3k8Lr00IlRv+AStkidgUQ=="
  }
}