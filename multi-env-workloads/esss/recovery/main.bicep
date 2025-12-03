@description('Logical environment name, e.g. dev, test, uat, prod')
param envName string

@description('Environment/name prefix used in resource names, e.g. esss-dev, esss-tst, esss-uat')
param namePrefix string

@description('Location for Recovery Services resources')
param location string = resourceGroup().location

@description('Target resource group ID where replicated VMs will be created')
param targetRGId string

@description('Target subnet ID where replicated NICs/VMs will connect')
param targetSubnetId string

@description('Array of VM replication configs')
param vmReplications array


@description('Recovery Point Retention in hours')
param recoveryPointRetentionHours int = 24

@description('App-consistent snapshot frequency in minutes')
param appConsistentSnapshotFrequencyMinutes int = 60

@description('Replication frequency in seconds')
param replicationFrequencyInSeconds int = 300

@description('Storage account type used for replication (Standard_LRS, Premium_LRS, etc.)')
param storageAccountType string = 'Standard_LRS'

@description(' Cache storage account resourceId used for replication staging')
param cacheStorageAccountId string = ''


// ---------- Recovery Services Vault ----------
module vaultModule './recoveryVault.bicep' = {
  name: 'rsv-${envName}'
  params: {
    namePrefix: namePrefix
    location: location
    // vaultName: 'override-if-needed'  // optional
  }
}


// ---------- ASR Replication Policy ----------
module policyModule './asrPolicy.bicep' = {
  name: 'asr-policy-${envName}'
  params: {
    namePrefix: namePrefix
    vaultName: vaultModule.outputs.vaultName
    recoveryPointRetentionHours: recoveryPointRetentionHours
    appConsistentSnapshotFrequencyInMinutes: appConsistentSnapshotFrequencyInMinutes
    replicationFrequencyInSeconds: replicationFrequencyInSeconds
    storageAccountType: storageAccountType
  }
}


// ---------- ASR Replication for VMs ----------
module replicationModule './asrReplication.bicep' = {
  name: 'asr-repl-${envName}'
  params: {
    vaultName: vaultModule.outputs.vaultName
    replicationPolicyId: policyModule.outputs.asrPolicyId
    targetRGId: targetRGId
    targetSubnetId: targetSubnetId
    cacheStorageAccountId: cacheStorageAccountId
    vmReplications: vmReplications
    // fabricName and protectionContainerName use defaults inside asrReplication.bicep
  }
}


// ---------- Outputs ----------
output vaultId string = vaultModule.outputs.vaultId
output vaultName string = vaultModule.outputs.vaultName

output asrPolicyId string = policyModule.outputs.asrPolicyId
output protectedVMIds array = replicationModule.outputs.protectedVMIds
