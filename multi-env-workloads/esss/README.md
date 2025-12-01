# **Multi-Environment Deployment (ASR Migration + Landing Zone)**

This repository contains the **Bicep-based multi-environment deployment framework** for the ESSS workloads.
It deploys all required Azure landing-zone components for **on-prem → Azure migration using ASR**, across:

* **DEV**
* **TEST**
* **UAT**
* **(Optional) PROD**

Each environment is deployed using the **same reusable Bicep modules** with separate parameter files.

---

# 📁 **Folder Structure**

```
esss/
├── monitoring/
│   ├── defender.bicep
│   ├── logAnalytics.bicep
│   └── main.bicep
│
├── networking/
│   ├── diagnostics.bicep
│   ├── main.bicep
│   ├── nsg.bicep
│   ├── subnet.bicep
│   └── vnet.bicep
│
├── recovery/
│   ├── asrPolicy.bicep
│   ├── asrReplication.bicep
│   ├── main.bicep
│   └── recoveryVault.bicep
│
├── dev.parameters.json
├── test.parameters.json
├── uat.parameters.json
└── main.bicep
```

---

# 🧩 **What This Deployment Includes**

### **1. Networking**

* Virtual Network (VNet)
* Multiple Subnets (parameter-driven)
* Network Security Groups (NSG)
* Diagnostic settings → Log Analytics Workspace

### **2. Monitoring**

* Log Analytics Workspace (LAW)
* Defender for Servers (Plan 1)
* Diagnostic extension integration

### **3. Recovery (ASR)**

* Recovery Services Vault (RSV)
* Replication Policy
* ASR protected items (VM replication configuration)
* Fully parameterized VM sizing + disk structure

### **4. Multi-Environment Support**

Each environment (DEV / TEST / UAT) has:

* Its own parameter file
* Its own target RG
  But **all share the same code modules**.

---

# 🔧 **Prerequisites**

Before deployment:

1. **Login** to Azure:

```bash
az login
```

2. **Install Bicep** (if not installed):

```bash
az bicep install
```

3. Make sure the target resource groups exist:

```bash
az group create -n esss-dev-rg  -l "Australia Southeast"
az group create -n esss-test-rg -l "Australia Southeast"
az group create -n esss-uat-rg  -l "Australia Southeast"
```

4. Ensure your user / service principal has:

* **Contributor** or **Owner** on each RG
* **Azure Site Recovery Contributor** is recommended (if restricted permissions)

---

# 📄 **Environment Parameter Files**

Each environment has its own JSON file:

* `dev.parameters.json`
* `test.parameters.json`
* `uat.parameters.json`

They define:

* `envName`, `envShort`
* Region (`location`)
* Target RG name
* VNet address space + subnets
* VM replication list (VM size, OS disk, data disks)

Example VM entry:

```json
{
  "vmName": "acurity-dev-01",
  "vmSize": "Standard_B4ms",
  "osType": "Windows",
  "osDiskSizeGB": 100,
  "dataDisks": [
    { "name": "data1", "sizeGB": 200 },
    { "name": "data2", "sizeGB": 500 }
  ]
}
```

---

# 🚀 **How to Deploy**

## **DEV Deployment**

```bash
az deployment group create \
  --resource-group esss-dev-rg \
  --template-file main.bicep \
  --parameters @dev.parameters.json
```

## **TEST Deployment**

```bash
az deployment group create \
  --resource-group esss-test-rg \
  --template-file main.bicep \
  --parameters @test.parameters.json
```

## **UAT Deployment**

```bash
az deployment group create \
  --resource-group esss-uat-rg \
  --template-file main.bicep \
  --parameters @uat.parameters.json
```

---

# 🔍 **Outputs**

After deployment, you will get:

| Output Name               | Description                      |
| ------------------------- | -------------------------------- |
| `vnetId`                  | ID of the VNet                   |
| `subnetIds`               | IDs of all environment subnets   |
| `logAnalyticsWorkspaceId` | LAW ID                           |
| `protectedVMIds`          | ASR protected VM objects created |

---

# ⚠️ **Important Notes**

### **1. ASR creates the VMs — Bicep does NOT**

During:

* Test Failover
* Failover
* Planned Failover

ASR automatically generates:

* VM
* Disks
* NICs
* Availability settings
* Attachments to VNet/Subnet

### **2. Managed Disk Mode (recommended)**

ASR will:

* NOT use custom storage accounts
* Automatically replicate disks as **managed disks**
* Require HNS to be **disabled** on any manually created storage account

### **3. Fully Parameterized**

All resources derive names using:

```
esss-{envShort}
```

So:

* DEV → esss-dev
* TEST → esss-tst
* UAT → esss-uat

No code changes needed per environment.

---

# 📚 **References**

* Azure Bicep – [https://learn.microsoft.com/azure/azure-resource-manager/bicep/](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
* Azure Site Recovery – [https://learn.microsoft.com/azure/site-recovery/](https://learn.microsoft.com/azure/site-recovery/)
* ASR with ARM/Bicep – [https://learn.microsoft.com/azure/site-recovery/azure-to-azure-tutorial-arm-template/](https://learn.microsoft.com/azure/site-recovery/azure-to-azure-tutorial-arm-template/)
