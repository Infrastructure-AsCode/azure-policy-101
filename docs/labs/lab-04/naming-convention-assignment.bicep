param parPolicyDefinitionName string = 'IAC-Naming-Convention'

var varPolicyAssignmentName = '[IAC] - Enforce Naming Convention'

resource resAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: varPolicyAssignmentName    
    properties: {      
      displayName: varPolicyAssignmentName
      policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policySetDefinitions', parPolicyDefinitionName) 
      parameters: {}        
    }
}

output outAssignmentId string = resAssignment.id
