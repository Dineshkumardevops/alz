@description('Environment prefix – example: esss-dev, esss-tst, esss-uat')
param namePrefix string

@description('Location for monitoring resources')
param location string = resourceGroup().location

@description('Log Analytics retention days')
param retentionInDays int = 30

@description('Defender Plan name')
param defenderPlanName string = 'ASCServer'


// ---------- Log Analytics Workspace ----------
module logAnalyticsModule 'logAnalytics.bicep' = {
  name: 'law-${namePrefix}'
  params: {
    namePrefix: namePrefix
    location: location
    retentionInDays: retentionInDays
  }
}

// ---------- Defender for Servers ----------
module defenderModule 'defender.bicep' = {
  name: 'defender-${namePrefix}'
  params: {
    defenderPlanName: defenderPlanName
    scopeId: resourceGroup().id
  }
}


// ---------- Outputs ----------
output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
output logAnalyticsWorkspaceName string = logAnalyticsModule.outputs.workspaceName
output defenderId string = defenderModule.outputs.defenderId
