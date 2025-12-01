@description('Environment/name prefix, e.g. esss-dev, esss-tst, esss-uat')
param namePrefix string

@description('Location for the Recovery Services Vault')
param location string = resourceGroup().location

@description('Optional explicit vault name override. If empty, a name will be generated from namePrefix.')
param vaultName string = ''

// If vaultName is not supplied, generate one from namePrefix
var effectiveVaultName = empty(vaultName) ? '${namePrefix}-rsv' : vaultName

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: effectiveVaultName
  location: location
  properties: {
    sku: {
      name: 'Standard'
    }
    publicNetworkAccess: 'Enabled'
  }
}

output vaultId string = recoveryVault.id
output vaultName string = recoveryVault.name
