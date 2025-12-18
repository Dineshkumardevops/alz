output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [for s in azurerm_subnet.subnets : s.id]
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.nsg.id
}
