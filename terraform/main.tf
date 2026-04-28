terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
  # Remote state — Azure Blob Storage
  backend "azurerm" {
    resource_group_name  = "rg-shopflow-tfstate"
    storage_account_name = "stshopflowtfstate"
    container_name       = "tfstate"
    key                  = "shopflow.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# ── Resource Group ─────────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── VNet Module ────────────────────────────────────────────────────
module "vnet" {
  source              = "./modules/vnet"
  name                = "vnet-shopflow-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = var.vnet_address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  tags                = var.tags
}

# ── ACR Module ─────────────────────────────────────────────────────
module "acr" {
  source              = "./modules/acr"
  name                = "acrshopflow${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags
}

# ── Key Vault Module ───────────────────────────────────────────────
module "keyvault" {
  source              = "./modules/keyvault"
  name                = "kv-shopflow-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags
}

# ── AKS Module ─────────────────────────────────────────────────────
module "aks" {
  source              = "./modules/aks"
  cluster_name        = "aks-shopflow-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  min_count           = var.min_count
  max_count           = var.max_count
  vm_size             = var.vm_size
  vnet_subnet_id      = module.vnet.aks_subnet_id
  tags                = var.tags
}

# ── Attach ACR to AKS (AcrPull role) ──────────────────────────────
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

# ── Key Vault Access for AKS Workload Identity ─────────────────────
resource "azurerm_role_assignment" "aks_keyvault" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.kubelet_identity_object_id
}
