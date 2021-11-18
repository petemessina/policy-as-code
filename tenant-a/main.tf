#Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# State Location
terraform {
  backend "azurerm" {
    resource_group_name   = "policy-as-code"
    storage_account_name  = "managedtenanttfstate"
    container_name        = "terraform"
    key                   = "terraform.tfstate"
  }
}

# Get Reference to Root Tenant Management Group
data "azurerm_management_group" "tenant_root_group" {
  name = var.management_group_name
}

# Reference Shared Modules
module "shared-policies" {
  source                  = "../shared-policies"

  management_group_id     = data.azurerm_management_group.tenant_root_group.id
  management_group_name   = data.azurerm_management_group.tenant_root_group.name
  enforce                 = var.enforce
  location                = var.location
  log_analytics_subscription_id       = var.log_analytics_subscription_id
  log_analytics_resource_group_name   = var.log_analytics_resource_group_name
  log_analytics_name                  = var.log_analytics_name
}
