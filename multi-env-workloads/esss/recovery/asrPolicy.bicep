@description('Environment/name prefix, e.g. esss-dev, esss-tst, esss-uat')
param namePrefix string

@description('Recovery Services Vault name')
param vaultName string

@description('Recovery Point Retention in hours')
param recoveryPointRetentionHours int = 24

@description('App-consistent snapshot frequency in minutes')
param appConsistentSnapshotFrequencyMinutes int = 60

@description('Replication frequency in seconds')
param replicationFrequencyInSeconds int = 300

@description('Storage account type used for replication (Standard_LRS, Premium_LRS, etc.)')
param storageAccountType string = 'Standard_LRS'

// Derive policy name from prefix (no dev/prod hardcoding)
var policyName = '${namePrefix}-asr-policy'

// Existing Recovery Services Vault
resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: vaultName
}

// ASR Replication Policy
resource asrPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2023-01-01' = {
  name: policyName
  parent: recoveryVault
  properties: {
    recoveryPointRetentionInHours: recoveryPointRetentionHours
    appConsistentSnapshotFrequencyInMinutes: appConsistentSnapshotFrequencyInMinutes
    replicationFrequencyInSeconds: replicationFrequencyInSeconds
    storageAccountType: storageAccountType
  }
}

output asrPolicyId string = asrPolicy.id
output asrPolicyName string = asrPolicy.name
