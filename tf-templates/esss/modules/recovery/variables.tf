variable "env_name" {
  description = "Logical environment name (dev, uat)"
  type        = string
}

variable "name_prefix" {
  description = "Environment prefix (esss-dev, esss-uat)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "target_rg_id" {
  description = "Target resource group ID where ASR VMs will be created"
  type        = string
}

variable "target_subnet_id" {
  description = "Target subnet ID for ASR failover NICs"
  type        = string
}

variable "vm_replications" {
  description = "VM replication configuration list"
  type = list(object({
    vm_name      = string
    vm_size      = string
    os_type      = string
    os_disk_size = number
    data_disks = list(object({
      name = string
      size = number
    }))
  }))
}

variable "cache_storage_account_id" {
  description = "Optional ASR cache storage account ID"
  type        = string
  default     = ""
}
