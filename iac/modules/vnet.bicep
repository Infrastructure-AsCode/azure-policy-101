param parLocation string
param parVirtualNetworkName string
param parVnetAddressPrefix string

resource resWorkloadNsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${parVirtualNetworkName}-workload-nsg'
  location: parLocation
  properties: {
    securityRules: [
      {
        name: 'DenyAllInbound'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllOutbound'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource resVnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: parVirtualNetworkName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parVnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'workload-snet'
        properties: {        
          addressPrefix: parVnetAddressPrefix
          networkSecurityGroup: {
            id: resWorkloadNsg.id
          }
        }
      }      
    ] 
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output outVnetName string = resVnet.name
output outVnetId string = resVnet.id
output outWorkloadSubnetId string = '${resVnet.id}/subnets/workload-snet'
output outWorkloadNsgId string = resWorkloadNsg.id
