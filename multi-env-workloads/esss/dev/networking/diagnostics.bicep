@description('Network watcher or diagnostic location')
param location string = resourceGroup().location

@description('Name for diagnostic settings')
param diagName string = 'network-diag'

@description('Log Analytics workspace ID')
param logAnalyticsWorkspaceId string

resource diag 'Microsoft.Insights/diagnosticSettings@2023-05-01-preview' = {
  name: diagName
  scope: resourceGroup()
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'NetworkSecurityGroupEvent'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
