# Use the same resource group where Terraform is executed
data "azurerm_resource_group" "current" {
  name = var.name_prefix
}

# -------------------------
# Virtual Network
# -------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current.name
  address_space       = [var.vnet_address_prefix]
}

# -------------------------
# Network Security Group
# -------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name_prefix}-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# -------------------------
# Subnets
# -------------------------
resource "azurerm_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.current.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]
}

# -------------------------
# NSG Association
# -------------------------
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = azurerm_subnet.subnets

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -------------------------
# Diagnostics for VNet
# -------------------------
resource "azurerm_monitor_diagnostic_setting" "vnet_diag" {
  name                       = "${var.name_prefix}-vnet-diag"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
