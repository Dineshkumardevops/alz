# Get current resource group (same RG where root deployment runs)
data "azurerm_resource_group" "current" {
  name = terraform.workspace != "" ? terraform.workspace : null
}

# -------------------------
# Log Analytics Workspace
# -------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name_prefix}-law"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
}

# -------------------------
# Microsoft Defender for Servers
# -------------------------
resource "azurerm_security_center_subscription_pricing" "defender_vm" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}
