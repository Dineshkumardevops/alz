output "vnet_id" {
  description = "VNet resource ID"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = module.networking.subnet_ids
}

output "recovery_vault_id" {
  description = "Recovery Services Vault ID"
  value       = module.recovery.vault_id
}

output "protected_vm_ids" {
  description = "ASR protected VM resource IDs"
  value       = module.recovery.protected_vm_ids
}
