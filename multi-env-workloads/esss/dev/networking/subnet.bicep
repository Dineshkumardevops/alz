@description('Subnet configuration')
param subnets array = [
  {
    name: 'dev-subnet'
    prefix: '10.0.1.0/24'
  }
]

@description('VNet resource ID')
param vnetId string

resource subnetResource 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = [for subnet in subnets: {
  parent: vnetId
  name: subnet.name
  properties: {
    addressPrefix: subnet.prefix
    privateEndpointNetworkPolicies: 'Enabled'
  }
}]

output subnetIds array = [for s in subnetResource: s.id]
