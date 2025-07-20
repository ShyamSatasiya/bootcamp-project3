# Providers
provider "azurerm" {
  features {}
  subscription_id = "522486cf-6fa2-4a9a-9c1a-a42442f4f761"
}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

# these are passed via environment or tfvars