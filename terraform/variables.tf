variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
  validation {
    condition     = contains(["East US", "West Europe", "Central India", "South India"], var.location)
    error_message = "Location must be one of: East US, West Europe, Central India, South India."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.28.5"
}

variable "node_count" {
  description = "Initial node count"
  type        = number
  default     = 2
}

variable "min_count" {
  description = "Minimum node count for autoscaler"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum node count for autoscaler"
  type        = number
  default     = 5
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
  validation {
    condition     = contains(["Standard_D2s_v3", "Standard_D4s_v3", "Standard_B2s"], var.vm_size)
    error_message = "VM size must be an approved size."
  }
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "AKS subnet prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    project     = "shopflow"
    managed_by  = "terraform"
    owner       = "sharad"
  }
}
