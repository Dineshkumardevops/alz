locals {
  name_prefix = "esss-${var.env_short}"
}

# Fetch existing target resource group
data "azurerm_resource_group" "target" {
  name = var.target_rg_name
}

# ---------------- Monitoring ----------------
module "monitoring" {
  source      = "./modules/monitoring"
  name_prefix = local.name_prefix
  location    = var.location
}

# ---------------- Networking ----------------
module "networking" {
  source              = "./modules/networking"
  name_prefix         = local.name_prefix
  location            = var.location
  vnet_address_prefix = var.vnet_address_prefix
  subnets             = var.subnets
  log_analytics_id    = module.monitoring.log_analytics_workspace_id
}

# ---------------- Recovery / ASR ----------------
module "recovery" {
  source                   = "./modules/recovery"
  env_name                 = var.env_name
  name_prefix              = local.name_prefix
  location                 = var.location
  target_rg_id             = data.azurerm_resource_group.target.id
  target_subnet_id         = module.networking.subnet_ids[0]
  vm_replications          = var.vm_replications
  cache_storage_account_id = var.cache_storage_account_id
}
