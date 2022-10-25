# Este archivo define los "proveedores" que se van a utilizar
# Como vamos a desplegar infraestructura en Azure, usamos AzureRM Provider
# Este archivo fue creado con la versión 3.24.0 de AzureRM Provider,
# Se toma como base esa versión, se permite cualquier superior a esa
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.24.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.28.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-shared-tfstate-eastus2"
    storage_account_name = "sa0tfstate0eastus201"
    container_name       = "tfstates"
    key                  = "tf-synaksarm-eastus02"
  }
}

# El bloque del provider contiene los parámetros para conectarse con Azure
# Se utiliza Service Princial y Client Secret (usuario y password)
# El client ID es una service account de AZURE AD
# En el tenant "Synchro Technologies S.A.", en la subscripción AZCORE02

provider "azurerm" {
  features {}
  tenant_id       = "bc07d099-091f-4ef3-aa8f-7bdf279319fb"     # Synchro Technologies S.A.alias
  subscription_id = "adae09ba-0d69-41b8-8219-e710f7c3e930"     # AZCORE02
  client_secret   = "OAb8Q~iuiXhin6rtE-Y6S_LZuGJ6hzUdSvcdxc_-" # azcore02-terraform-hantolini password
  client_id       = "65d63c12-4d54-41aa-abab-dd3703eb8d6b"     # azcore02-terraform-hantolini username
}
