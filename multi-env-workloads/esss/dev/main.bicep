param location string = resourceGroup().location

// ---------------- Networking ----------------
param logAnalyticsWorkspaceId string

module networking 'networking/main.bicep' = {
  name: 'networkingDeployment'
  params: {
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

// ---------------- Monitoring ----------------
module monitoring 'monitoring/main.bicep' = {
  name: 'monitoringDeployment'
  params: {
    location: location
  }
}

// ---------------- Recovery ----------------
param targetRG string
module recovery 'recovery/main.bicep' = {
  name: 'recoveryDeployment'
  params: {
    location: location
    targetRG: targetRG
    targetSubnetId: networking.outputs.subnetIds[0]
  }
}

// ---------------- Outputs ----------------
output vnetId string = networking.outputs.vnetId
output subnetIds array = networking.outputs.subnetIds
output nsgId string = networking.outputs.nsgId
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
output defenderId string = monitoring.outputs.defenderId
output protectedVMId string = recovery.outputs.protectedVMId
