@description('Subnet configuration. Each item: { name: string, prefix: string }')
param subnets array

@description('Name of the existing VNet where subnets will be created')
param vnetName string

@description('Location of the VNet/subnets')
param location string = resourceGroup().location

// Existing VNet (created in vnet.bicep)
resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vnetName
}

resource subnetResource 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = [
  for subnet in subnets: {
    name: subnet.name
    parent: vnet
    properties: {
      addressPrefix: subnet.prefix
      privateEndpointNetworkPolicies: 'Enabled'
    }
  }
]

output subnetIds array = [for s in subnetResource: s.id]
output subnetNames array = [for s in subnetResource: s.name]
