targetScope = 'subscription'

param parPolicyAssignmentName string = '[IAC] - Enforce NSG flow logs'
param parPolicyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/0db34a60-64f4-4bf6-bd44-f95c16cf34b9'
param parLocation string = 'norwayeast'

var varUniqueString = uniqueString(subscription().id)
var varStorageAccountName = take('nsglogs${varUniqueString}', 24)

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: varStorageAccountName
  scope: resourceGroup('iac-ws7-rg')
}

resource resAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: 'Enforce-NSG-Flow-Logs'
    location: parLocation
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
      displayName: parPolicyAssignmentName
      policyDefinitionId: parPolicyDefinitionID
      
      parameters: {
        nsgRegion: {
          value: parLocation
        }
        storageId: {
          value: resStorageAccount.id
        }
        networkWatcherRG: {
          value: 'NetworkWatcherRG'
        }
        networkWatcherName: {
          value: 'NetworkWatcher_${parLocation}'
        }
      }        
    }
}

var varContributorRoleDefinitionId = '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resAssignment.name, resAssignment.type)
  properties: {
    principalId: resAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: varContributorRoleDefinitionId
  }
}

output outAssignmentId string = resAssignment.id
