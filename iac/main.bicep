targetScope = 'subscription'

@description('Lab resources prefix.')
param parPrefix string = 'iac-ws7'

param parLocation string = 'norwayeast'

var varHubResourceGroupName = '${parPrefix}-rg'
var varEastUSRegion = 'eastus'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: varHubResourceGroupName
  location: parLocation
}

module modComplaintHub 'modules/vnet.bicep' = {
  scope: resResourceGroup
  name: 'deploy-vnet1'
  params: {
    parLocation: parLocation
    parVirtualNetworkName: '${parPrefix}-vnet'
    parVnetAddressPrefix: '10.10.0.0/25'
  }
}

module modNonComplaintHub 'modules/vnet.bicep' = {
  scope: resResourceGroup
  name: 'deploy-vnet2'
  params: {
    parLocation: varEastUSRegion
    parVirtualNetworkName: 'vnet2'
    parVnetAddressPrefix: '10.11.0.0/25'
  }
}

module modLogAnalytics 'modules/law.bicep' = {
  scope: resResourceGroup
  name: 'deploy-log-analytics-workspace'
  params: {
    parLocation: parLocation
    parPrefix: parPrefix
  }
}

var varUniqueString = uniqueString(subscription().id)
module modComplaintSA 'modules/sa.bicep' = {
  name: 'deploy-sa1'
  scope: resResourceGroup
  params: {
    parLocation: parLocation
    parStorageAccountName: take('norwayeast${varUniqueString}', 24)
  }
}

module modNoncomplaintSA 'modules/sa.bicep' = {
  name: 'deploy-sa2'
  scope: resResourceGroup
  params: {
    parLocation: varEastUSRegion
    parStorageAccountName: take('${varEastUSRegion}${varUniqueString}', 24)
  }
}
