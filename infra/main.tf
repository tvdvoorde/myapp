terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.49.0"
    }
    # azuread = {
    #   source = "hashicorp/azuread"
    #   #   version = "=2.47.0"
    # }
  }
  backend "azurerm" {
    container_name = "tfstate"
    key            = "overriden-in-github-actions.yml"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
  }
}

data "azurerm_resource_group" "infra" {
  name = "rg-linc-${var.environment}"
}

variable "environment" {
  default = ""
}

variable "web_app_name" {
  default = ""
}

data "azurerm_client_config" "current" {
}


resource "azurerm_service_plan" "myappplan" {
  name                = "asp-myapp-${var.environment}"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name
  os_type             = "Linux"
  sku_name            = "F1"
}


resource "azurerm_linux_web_app" "myapp" {
  name                = var.web_app_name
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name
  service_plan_id     = azurerm_service_plan.myappplan.id

  site_config {
    always_on = false
    application_stack {
      node_version = "20-lts"
    }
  }
}

output "url" {
  value = azurerm_linux_web_app.myapp.default_hostname
}