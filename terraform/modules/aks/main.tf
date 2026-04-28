# AKS Module — Written from scratch
# This is exactly what interviewers mean by "Terraform modules from scratch"

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

# ── AKS Cluster ────────────────────────────────────────────────────
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  # System node pool
  default_node_pool {
    name                = "systempool"
    node_count          = var.node_count
    vm_size             = var.vm_size
    vnet_subnet_id      = var.vnet_subnet_id
    os_disk_size_gb     = 100
    type                = "VirtualMachineScaleSets"

    # Enable Cluster Autoscaler
    enable_auto_scaling = true
    min_count           = var.min_count
    max_count           = var.max_count

    # Upgrade settings — max surge for zero downtime upgrades
    upgrade_settings {
      max_surge = "33%"
    }

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.tags["environment"] != null ? var.tags["environment"] : "dev"
    }
  }

  # Managed Identity (no service principal needed)
  identity {
    type = "SystemAssigned"
  }

  # RBAC with Azure AD
  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  # Network profile
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  # Enable Key Vault secret provider (for External Secrets)
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  # Monitoring
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  tags = var.tags
}

# ── Log Analytics Workspace ────────────────────────────────────────
resource "azurerm_log_analytics_workspace" "aks" {
  name                = "law-${var.cluster_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ── User Node Pool (for workloads) ─────────────────────────────────
resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size
  node_count            = 1
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = var.max_count
  vnet_subnet_id        = var.vnet_subnet_id
  mode                  = "User"

  node_labels = {
    "nodepool-type" = "workload"
  }

  upgrade_settings {
    max_surge = "33%"
  }

  tags = var.tags
}
