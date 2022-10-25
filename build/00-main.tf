# El bloque del provider contiene los parámetros para conectarse con Azure
# Se utiliza Service Princial y Client Secret (usuario y password)
# El client ID es una service account de AZURE AD
# En el tenant "Synchro Technologies S.A.", en la subscripción AZCORE02

locals {
  htags = {
    "CONTACT" = "hugo.antolini@synchro-technologies.com"
    "DATE"    = formatdate("YYYYMMDD", timestamp())
    "ENV"     = "PROD"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-synaks-armtest-eastus2"
  location = "eastus2"
  tags     = local.htags
}

resource "azurerm_storage_account" "this" {
  name                     = "sa0synaks0armtest001"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags                     = local.htags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-synaks-armtest-eastus2"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.htags
}

resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.this.name
  location              = azurerm_resource_group.this.location
  workspace_name        = azurerm_log_analytics_workspace.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
  tags = local.htags
}