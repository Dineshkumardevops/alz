@description('Name prefix for the VNet')
param namePrefix string

@description('Address prefix for the VNet')
param vnetAddressPrefix string

@description('Resource group location')
param location string = resourceGroup().location

var vnetName = '${namePrefix}-vnet'

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
output vnetName string = vnet.name
