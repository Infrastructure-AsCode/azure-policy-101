param parPolicyAssignmentName string = '[IAC] - Inherit IAC-Owner tag from the subscription'
param parPolicyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/b27a0cbd-a167-4dfa-ae64-4337be671140'
param parLocation string = resourceGroup().location

resource resAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: parPolicyAssignmentName
    location: parLocation
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
      displayName: parPolicyAssignmentName
      policyDefinitionId: parPolicyDefinitionID
      parameters: {          
        tagName: {
          value: 'IAC-Owner'
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
