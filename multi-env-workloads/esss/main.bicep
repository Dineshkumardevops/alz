@description('Logical environment name, e.g. dev, test, uat, prod')
param envName string

@description('Short env suffix used in names: dev, tst, uat, prd')
param envShort string

@description('Deployment location')
param location string

@description('Target resource group name where VMs will be created during ASR failover')
param targetRGName string

@description('Address space for the VNet')
param vnetAddressPrefix string

@description('List of subnets: [{ name: string, prefix: string }]')
param subnets array

@description('VM replication configuration list')
param vmReplications array

@description('Optional: Cache storage account resourceId used by ASR for replication staging. Leave empty to use ASR internal handling.')
param cacheStorageAccountId string = ''

// Common naming prefix for resources
var namePrefix = 'esss-${envShort}'


// ---------- Fetch existing Target RG ----------
resource targetRG 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: targetRGName
}


// ---------- Monitoring Layer ----------
module monitoring './monitoring/main.bicep' = {
  name: 'monitoring-${envName}'
  params: {
    namePrefix: namePrefix
    location: location
  }
}


// ---------- Networking Layer ----------
module networking './networking/main.bicep' = {
  name: 'networking-${envName}'
  params: {
    namePrefix: namePrefix
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    subnets: subnets
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
  }
}


// ---------- Recovery / ASR Layer ----------
module recovery './recovery/main.bicep' = {
  name: 'recovery-${envName}'
  params: {
    envName: envName
    namePrefix: namePrefix
    location: location
    targetRGId: targetRG.id
    targetSubnetId: networking.outputs.subnetIds[0]
    vmReplications: vmReplications
    cacheStorageAccountId: cacheStorageAccountId
  }
}


// ---------- Outputs ----------
output vnetId string = networking.outputs.vnetId
output subnetIds array = networking.outputs.subnetIds
output protectedVMIds array = recovery.outputs.protectedVMIds
