param namePrefix string
param location string = resourceGroup().location
param retentionInDays int = 30

var workspaceName = '${namePrefix}-law'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

output workspaceId string = logAnalytics.id
output workspaceName string = logAnalytics.name
