param parNSGName string = 'iac-ws7-test-nsg'
param parLocation string = resourceGroup().location

resource resNSG 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: parNSGName
  location: parLocation
  properties: {
    securityRules: []
  }
}
