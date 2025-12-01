@description('Recovery Services Vault name')
param vaultName string = 'dev-rsv'

@description('Location for the vault')
param location string = resourceGroup().location

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      name: 'Standard'
    }
    publicNetworkAccess: 'Enabled'
  }
}

output vaultId string = recoveryVault.id
output vaultNameOutput string = recoveryVault.name
