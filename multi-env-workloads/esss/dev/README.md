
# DEV Environment Deployment – ASR Migration

This folder contains the **Bicep templates and parameters** required to deploy the DEV environment for ASR-based migration from on-premises to Azure.

The deployment includes:

* **Networking**: VNet, subnets, NSG, diagnostics
* **Monitoring**: Log Analytics workspace, Microsoft Defender for Servers
* **Recovery**: Recovery Services Vault, ASR replication policy, protected VMs (VM sizes & disks configured)

---

## Folder Structure

```
dev/
├── networking/
│   ├── vnet.bicep
│   ├── subnet.bicep
│   ├── nsg.bicep
│   ├── diagnostics.bicep
│   └── main.bicep
├── monitoring/
│   ├── logAnalytics.bicep
│   ├── defender.bicep
│   └── main.bicep
├── recovery/
│   ├── recoveryVault.bicep
│   ├── asrPolicy.bicep
│   ├── asrReplication.bicep
│   └── main.bicep
├── main.bicep
└── parameters.json
```

---

## Prerequisites

1. **Azure CLI** installed and logged in.
2. **Owner or Contributor access** on the target subscription/resource group.
3. **Bicep CLI** installed (`az bicep install` if not already).
4. **Target Resource Group** for DEV environment created (e.g., `dev-rg`).

---

## Parameters

* `location` – Azure region (set to `Australia Southeast` for DEV).
* `targetRG` – Resource group where ASR-protected VMs will be created.
* `logAnalyticsWorkspaceId` – Optional. Can be left blank; main deployment will create the workspace.

---

## Deployment Steps

1. **Clone or navigate** to the DEV folder:

```bash
cd workloads/esss/dev
```

2. **Deploy the environment** using Azure CLI:

```bash
az deployment group create \
  --resource-group dev-rg \
  --template-file main.bicep \
  --parameters @parameters.json
```

> This deploys networking, monitoring, and ASR recovery resources in sequence.

3. **Verify outputs**:

* `vnetId`, `subnetIds`, `nsgId` → networking resources
* `logAnalyticsWorkspaceId` → monitoring workspace
* `protectedVMId` → ASR-protected VM ready for failover

---

## Notes

* **VMs are not deployed directly** via Bicep; ASR will create them automatically during **failover/test failover**.
* **VM sizes and disk configurations** are defined in the `recovery/asrReplication.bicep` file.
* **Diagnostics** are attached to the Log Analytics workspace for monitoring.
* **Defender for Servers** is enabled for security insights.


---

## References

* [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)
* [Azure Site Recovery (ASR) Overview](https://learn.microsoft.com/en-us/azure/site-recovery/overview)
* [Deploy ASR Protected Items using ARM/Bicep](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-tutorial-arm-template)


