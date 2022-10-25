# Este bloque contiene los recursos necesarios para la creación del cluster AKS
# Se definen los siguientes recursos:
#

data "azurerm_virtual_network" "vnet" {
  name                = "vnet-shared-eastus2-01"
  resource_group_name = "rg-sharedservices-eastus2"
}

data "azurerm_subnet" "snetdefault" {
  name                 = "snet-default"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_container_registry" "synazreg" {
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  name                = "synazreg"
}

data "azuread_group" "grpaksadmin" {
  display_name     = "SynAzKub Administrators"
  security_enabled = true
}

resource "azurerm_subnet" "this" {
  name                 = "snet-aksarmtest"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.183.0/24"]
  delegation {
    name = "aks-delegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "synaks-armtest-eastus2"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  dns_prefix          = "synaks-armtest"
  kubernetes_version  = "1.24.3"

  default_node_pool {
    name           = "system00"
    node_count     = 1
    vm_size        = "Standard_E2ps_v5"
    max_pods       = 80
    pod_subnet_id  = azurerm_subnet.this.id
    vnet_subnet_id = data.azurerm_subnet.snetdefault.id
    tags           = local.htags
  }
  node_resource_group = "rg-synaks-armtest-eastus2-nodes"

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [data.azuread_group.grpaksadmin.object_id]
  }

  network_profile {
    network_plugin = "azure"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  tags = local.htags
}

resource "azurerm_role_assignment" "aksarmacrpull" {
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.synazreg.id
  skip_service_principal_aad_check = true
}
