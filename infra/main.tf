terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.7.2"
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

data "azurerm_client_config" "current" {
}


resource "azurerm_service_plan" "myappplan" {
  name                = "asp-myapp-${var.environment}"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name
  os_type             = "Linux"
  sku_name            = "F1"
}


resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_linux_web_app" "myapp" {
  name                = "app-myapp${random_integer.suffix.result}-${var.environment}"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name
  service_plan_id     = azurerm_service_plan.myappplan.id

  site_config {
    always_on = false
    application_stack {
      python_version = "3.13"
    }
  }
}

output "url" {
  value = azurerm_linux_web_app.myapp.default_hostname
}