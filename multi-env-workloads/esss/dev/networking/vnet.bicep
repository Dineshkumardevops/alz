@description('Name of the Virtual Network')
param vnetName string = 'dev-vnet'

@description('Address prefix for the VNet')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Resource group location')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

output vnetId string = vnet.id
