@description('Replication policy name')
param policyName string = 'dev-asr-policy'

@description('Recovery Services Vault ID')
param vaultId string

@description('Recovery Point Retention in hours')
param recoveryPointRetentionHours int = 24

@description('App-consistent snapshot frequency in minutes')
param appConsistentSnapshotFrequencyMinutes int = 60

resource asrPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2023-01-01' = {
  name: policyName
  parent: vaultId
  properties: {
    recoveryPointRetentionInHours: recoveryPointRetentionHours
    appConsistentSnapshotFrequencyInMinutes: appConsistentSnapshotFrequencyMinutes
    replicationFrequencyInSeconds: 300
    replicationEligibility: 'Eligible'
    storageAccountType: 'Standard_LRS'
  }
}

output asrPolicyId string = asrPolicy.id
