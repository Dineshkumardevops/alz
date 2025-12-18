output "vault_id" {
  description = "Recovery Services Vault ID"
  value       = azurerm_recovery_services_vault.rsv.id
}

output "vault_name" {
  description = "Recovery Services Vault name"
  value       = azurerm_recovery_services_vault.rsv.name
}

output "protected_vm_ids" {
  description = "ASR protected VM IDs"
  value       = [for v in azapi_resource.asr_protected_vm : v.id]
}
