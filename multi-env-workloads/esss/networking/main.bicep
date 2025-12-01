@description('Environment prefix used in names, e.g. esss-dev, esss-tst, esss-uat')
param namePrefix string

@description('Location for networking resources')
param location string = resourceGroup().location

@description('Address prefix for the VNet')
param vnetAddressPrefix string

@description('Subnet configuration array: [{ name: string, prefix: string }]')
param subnets array

@description('Log Analytics workspace ID for diagnostics')
param logAnalyticsWorkspaceId string

@description('NSG rules to apply')
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


// ---------- VNet ----------
module vnetModule 'vnet.bicep' = {
  name: 'vnet-${namePrefix}'
  params: {
    namePrefix: namePrefix
    vnetAddressPrefix: vnetAddressPrefix
    location: location
  }
}


// ---------- Subnets ----------
module subnetModule 'subnet.bicep' = {
  name: 'subnets-${namePrefix}'
  params: {
    vnetName: vnetModule.outputs.vnetName
    subnets: subnets
    location: location
  }
}


// ---------- NSG ----------
module nsgModule 'nsg.bicep' = {
  name: 'nsg-${namePrefix}'
  params: {
    namePrefix: namePrefix
    location: location
    nsgRules: nsgRules
  }
}


// ---------- Diagnostics ----------
module diagModule 'diagnostics.bicep' = {
  name: 'diag-${namePrefix}'
  params: {
    location: location
    diagName: '${namePrefix}-net-diag'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}


// ---------- Outputs ----------
output vnetId string = vnetModule.outputs.vnetId
output vnetName string = vnetModule.outputs.vnetName

output subnetIds array = subnetModule.outputs.subnetIds
output subnetNames array = subnetModule.outputs.subnetNames

output nsgId string = nsgModule.outputs.nsgId
output nsgName string = nsgModule.outputs.nsgName
