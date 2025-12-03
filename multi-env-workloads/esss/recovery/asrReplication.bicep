@description('Recovery Services Vault name')
param vaultName string

@description('ASR Replication Policy ID')
param replicationPolicyId string

@description('Target resource group ID where replicated VMs will be created')
param targetRGId string

@description('Target subnet ID where replicated NICs/VMs will connect')
param targetSubnetId string

@description('ASR Fabric name (usually Azure)')
param fabricName string = 'Azure'

@description('ASR Protection Container name')
param protectionContainerName string = 'protectionContainer1'

@description('Optional: Cache storage account resourceId used for replication staging (matches the portal UI)')
param cacheStorageAccountId string = ''

@description('Array of VM replication configs')
param vmReplications array


// ---------- Existing ASR Hierarchy ----------

// Existing Recovery Services Vault
resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: vaultName
}

// Existing Fabric under the vault
resource fabric 'Microsoft.RecoveryServices/vaults/replicationFabrics@2023-01-01' existing = {
  name: '${recoveryVault.name}/${fabricName}'
}

// Existing Protection Container under the fabric
resource protectionContainer 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers@2023-01-01' existing = {
  name: '${fabric.name}/${protectionContainerName}'
}


// ---------- Protected VMs ----------
resource protectedVMs 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectedItems@2023-01-01' = [
  for vm in vmReplications: {
    name: vm.vmName
    parent: protectionContainer
    properties: {
      policyId: replicationPolicyId
      protectionState: 'Protected'
      providerSpecificDetails: {
        instanceType: 'HyperVReplicaAzure'
        vmSize: vm.vmSize
        osType: vm.osType
        targetResourceGroupId: targetRGId
        targetSubnetId: targetSubnetId

      
        // ASR's internal handling / managed cache.
        targetStorageAccountId: cacheStorageAccountId

        // Disks: OS + Data
        disks: [
          {
            name: 'OSDisk'
            sizeInGB: vm.osDiskSizeGB
            diskType: 'OS'
          }
        ] ++ [
          for d in vm.dataDisks: {
            name: d.name
            sizeInGB: d.sizeGB
            diskType: 'Data'
          }
        ]
      }
    }
  }
]

output protectedVMIds array = [for p in protectedVMs: p.id]
output protectedVMNames array = [for p in protectedVMs: p.name]
