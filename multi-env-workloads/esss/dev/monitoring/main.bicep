param location string = resourceGroup().location

module logAnalyticsModule 'logAnalytics.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: 'dev-law'
    location: location
    retentionInDays: 30
  }
}

module defenderModule 'defender.bicep' = {
  name: 'defenderDeployment'
  params: {
    defenderPlanName: 'ASCServer'
    scopeId: resourceGroup().id
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
output logAnalyticsCustomerId string = logAnalyticsModule.outputs.workspaceCustomerId
output defenderId string = defenderModule.outputs.defenderId
