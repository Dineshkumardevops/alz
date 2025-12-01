@description('Log Analytics workspace name')
param workspaceName string = 'dev-law'

@description('Location for Log Analytics workspace')
param location string = resourceGroup().location

@description('Retention days for logs')
param retentionInDays int = 30

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output workspaceId string = logAnalytics.id
output workspaceCustomerId string = logAnalytics.properties.customerId
