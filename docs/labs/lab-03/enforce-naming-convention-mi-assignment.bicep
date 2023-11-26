param parPolicyDefinitionName string = 'Enforce-NamingConvention-Resources'

var varPolicyAssignmentName = '[IAC] - Enforce NamingConvention for Managed Identity'

resource resAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: varPolicyAssignmentName    
    properties: {      
      displayName: varPolicyAssignmentName
      policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', parPolicyDefinitionName) 
      parameters: {
        resourceType: {
          value: 'Microsoft.ManagedIdentity/userAssignedIdentities'
        }
        resourceAbbreviation:{
          value: 'mi'
        }
      }        
    }
}

output outAssignmentId string = resAssignment.id
