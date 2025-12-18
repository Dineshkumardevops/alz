# -------------------------
# Environment
# -------------------------
env_name  = "dev"
env_short = "dev"
location  = "Australia East"

# -------------------------
# Target Resource Group
# -------------------------
target_rg_name = "esss-dev-rg"

# -------------------------
# Networking
# -------------------------
vnet_address_prefix = "10.0.0.0/16"

subnets = [
  {
    name   = "app-subnet"
    prefix = "10.0.1.0/24"
  }
]

# -------------------------
# ASR VM Replication Config
# -------------------------
vm_replications = [
  {
    vm_name      = "acurity-dev-01"
    vm_size      = "Standard_B4ms"
    os_type      = "Windows"
    os_disk_size = 100
    data_disks = [
      { name = "data1", size = 200 },
      { name = "data2", size = 500 }
    ]
  },
  {
    vm_name      = "cm-dev-01"
    vm_size      = "Standard_B4ms"
    os_type      = "Windows"
    os_disk_size = 100
    data_disks = [
      { name = "data1", size = 200 },
      { name = "data2", size = 500 }
    ]
  }
]

# -------------------------
# Optional ASR Cache Storage
# -------------------------
cache_storage_account_id = ""
