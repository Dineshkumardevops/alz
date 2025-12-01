@description('Environment name or prefix, e.g. dev, tst, uat, prod')
param namePrefix string

@description('Location of NSG')
param location string = resourceGroup().location

@description('List of NSG rules')
param nsgRules array = [
  {
    name: 'Allow-RDP'
    priority: 1000
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
  }
]

var nsgName = '${namePrefix}-nsg'

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      for rule in nsgRules: {
        name: rule.name
        properties: {
          priority: rule.priority
          direction: rule.direction
          access: rule.access
          protocol: rule.protocol
          sourcePortRange: rule.sourcePortRange
          destinationPortRange: rule.destinationPortRange
          sourceAddressPrefix: rule.sourceAddressPrefix
          destinationAddressPrefix: rule.destinationAddressPrefix
        }
      }
    ]
  }
}

output nsgId string = nsg.id
output nsgName string = nsg.name
