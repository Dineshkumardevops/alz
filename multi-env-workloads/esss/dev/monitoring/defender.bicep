@description('Defender plan for servers')
param defenderPlanName string = 'ASCServer'

@description('Resource scope for Defender')
param scopeId string = resourceGroup().id

resource defender 'Microsoft.Security/pricings@2022-01-01-preview' = {
  name: defenderPlanName
  scope: scopeId
  properties: {
    pricingTier: 'Standard'
  }
}

output defenderId string = defender.id
