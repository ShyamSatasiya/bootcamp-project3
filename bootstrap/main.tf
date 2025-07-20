provider "azurerm" {
  features {}
  subscription_id = "522486cf-6fa2-4a9a-9c1a-a42442f4f761"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tfstate"
  location = "canadacentral"
}

resource "azurerm_storage_account" "sa" {
  name                     = "sttfstate${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "c" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
