variable "env_name" {
  description = "Logical environment name (dev, uat)"
  type        = string
}

variable "env_short" {
  description = "Short environment code (dev, uat)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "target_rg_name" {
  description = "Target resource group where ASR VMs will be created on failover"
  type        = string
}

variable "vnet_address_prefix" {
  description = "VNet CIDR range"
  type        = string
}

variable "subnets" {
  description = "Subnet definitions"
  type = list(object({
    name   = string
    prefix = string
  }))
}

variable "vm_replications" {
  description = "VM replication configuration list"
  type = list(object({
    vm_name        = string
    vm_size        = string
    os_type        = string
    os_disk_size   = number
    data_disks = list(object({
      name = string
      size = number
    }))
  }))
}

variable "cache_storage_account_id" {
  description = "Optional ASR replication cache storage account ID"
  type        = string
  default     = ""
}
