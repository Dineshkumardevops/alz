# Use current resource group (same RG as Terraform deployment)
data "azurerm_resource_group" "current" {
  name = split("/", var.target_rg_id)[4]
}

# -------------------------------------------------
# Recovery Services Vault
# -------------------------------------------------
resource "azurerm_recovery_services_vault" "rsv" {
  name                = "${var.name_prefix}-rsv"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current.name
  sku                 = "Standard"
}

# -------------------------------------------------
# ASR Replication Policy
# -------------------------------------------------
resource "azurerm_site_recovery_replication_policy" "policy" {
  name     = "${var.name_prefix}-policy"
  vault_id = azurerm_recovery_services_vault.rsv.id

  recovery_point_retention_in_minutes                   = 1440
  application_consistent_snapshot_frequency_in_minutes  = 60
}

# -------------------------------------------------
# ASR Protected Items (VMs)
# Uses azapi because azurerm does not expose this
# -------------------------------------------------
resource "azapi_resource" "asr_protected_vm" {
  for_each = { for vm in var.vm_replications : vm.vm_name => vm }

  type      = "Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectedItems@2023-01-01"
  name      = each.key
  parent_id = "${azurerm_recovery_services_vault.rsv.id}/replicationFabrics/Azure/replicationProtectionContainers/protectionContainer1"

  body = jsonencode({
    properties = {
      policyId = azurerm_site_recovery_replication_policy.policy.id

      providerSpecificDetails = {
        instanceType = "HyperVReplicaAzure"
        vmSize       = each.value.vm_size
        osType       = each.value.os_type

        targetResourceGroupId = var.target_rg_id
        targetSubnetId        = var.target_subnet_id

        # Optional cache storage account (matches portal UI)
        targetStorageAccountId = var.cache_storage_account_id
      }
    }
  })
}
