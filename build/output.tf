output "k8s_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "k8s_kubeconfig" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive = true
}

output "k8s_clientkey" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key
  sensitive = true
}

output "k8s_clientcertificate" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate
  sensitive = true
}

output "k8s_clustercacertificate" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate
  sensitive = true
}

output "k8s_host" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config.0.host
  sensitive = true
}