param location string = resourceGroup().location
param logAnalyticsWorkspaceId string

module vnetModule 'vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    location: location
  }
}

module subnetModule 'subnet.bicep' = {
  name: 'subnetDeployment'
  params: {
    vnetId: vnetModule.outputs.vnetId
    subnets: [
      {
        name: 'dev-subnet'
        prefix: '10.0.1.0/24'
      }
    ]
  }
}

module nsgModule 'nsg.bicep' = {
  name: 'nsgDeployment'
  params: {
    location: location
  }
}

module diagModule 'diagnostics.bicep' = {
  name: 'diagDeployment'
  params: {
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

output vnetId string = vnetModule.outputs.vnetId
output subnetIds array = subnetModule.outputs.subnetIds
output nsgId string = nsgModule.outputs.nsgId
