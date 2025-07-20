terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate3766"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}