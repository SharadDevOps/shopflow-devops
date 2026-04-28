output "cluster_id"                  { value = azurerm_kubernetes_cluster.aks.id }
output "cluster_name"                { value = azurerm_kubernetes_cluster.aks.name }
output "kube_config"                 { value = azurerm_kubernetes_cluster.aks.kube_config_raw; sensitive = true }
output "kubelet_identity_object_id"  { value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id }
output "cluster_identity_object_id"  { value = azurerm_kubernetes_cluster.aks.identity[0].principal_id }
output "log_analytics_workspace_id"  { value = azurerm_log_analytics_workspace.aks.id }
