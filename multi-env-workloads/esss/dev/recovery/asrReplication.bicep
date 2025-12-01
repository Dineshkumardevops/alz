@description('Recovery Services Vault name')
param vaultName string

@description('Replication Policy ID')
param replicationPolicyId string

@description('Target resource group where VM will be created')
param targetRG string

@description('Target VNet/Subnet ID')
param targetSubnetId string

@description('VM Size for failover')
param vmSize string = 'Standard_B4ms'

@description('OS Disk and Data Disks configuration')
param osDiskSizeGB int = 100
param dataDisks array = [
  {
    name: 'D'
    sizeGB: 200
  },
  {
    name: 'D2'
    sizeGB: 500
  }
]

@description('VM OS type')
param osType string = 'Windows'

@description('Name of the VM to protect')
param vmName string

resource protectedVM 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectedItems@2023-01-01' = {
  name: '${vaultName}/Azure/protectionContainer1/${vmName}'
  properties: {
    policyId: replicationPolicyId
    protectionState: 'Protected'
    providerSpecificDetails: {
      instanceType: 'HyperVReplicaAzure'
      vmSize: vmSize
      osType: osType
      targetAvailabilitySetId: ''
      targetResourceGroupId: targetRG
      disks: [
        {
          name: 'OSDisk'
          sizeInGB: osDiskSizeGB
          diskType: 'OS'
        }
      ] + [for d in dataDisks: {
        name: d.name
        sizeInGB: d.sizeGB
        diskType: 'Data'
      }]
      targetSubnetId: targetSubnetId
    }
  }
}

output protectedVMId string = protectedVM.id
