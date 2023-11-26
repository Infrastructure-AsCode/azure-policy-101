targetScope = 'subscription'

var varPolicyAssignmentName = '[IAC] - Enforce NamingConvention for ResourceGroups'

resource resEnforceNamingConventionResourceGroup 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: 'Enforce-NamingConvention-ResourceGroup'
}

resource resAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: varPolicyAssignmentName    
    properties: {      
      displayName: varPolicyAssignmentName
      policyDefinitionId: resEnforceNamingConventionResourceGroup.id
      parameters: {}        
    }
}

output outAssignmentId string = resAssignment.id
