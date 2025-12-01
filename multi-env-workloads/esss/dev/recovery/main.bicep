param location string = resourceGroup().location
param targetRG string
param targetSubnetId string

module vaultModule 'recoveryVault.bicep' = {
  name: 'rsvDeployment'
  params: {
    vaultName: 'dev-rsv'
    location: location
  }
}

module policyModule 'asrPolicy.bicep' = {
  name: 'policyDeployment'
  params: {
    vaultId: vaultModule.outputs.vaultId
    policyName: 'dev-asr-policy'
    recoveryPointRetentionHours: 24
    appConsistentSnapshotFrequencyMinutes: 60
  }
}

module replicationModule 'asrReplication.bicep' = {
  name: 'replicationDeployment'
  params: {
    vaultName: vaultModule.outputs.vaultNameOutput
    replicationPolicyId: policyModule.outputs.asrPolicyId
    targetRG: targetRG
    targetSubnetId: targetSubnetId
    vmSize: 'Standard_B4ms'
    osDiskSizeGB: 100
    dataDisks: [
      { name: 'D', sizeGB: 200 }
      { name: 'D2', sizeGB: 500 }
    ]
    osType: 'Windows'
    vmName: 'AcurItySecVM1'
  }
}

output protectedVMId string = replicationModule.outputs.protectedVMId
