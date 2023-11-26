
targetScope = 'subscription'

resource resEnforceNamingConventionResources 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: 'Enforce-NamingConvention-Resources'
}

resource policySetDef 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'IAC-Naming-Convention'
  properties: {
    policyDefinitions: [
      {    
        policyDefinitionReferenceId: 'Enforce-NamingConvention-ManagedIdentity'    
        policyDefinitionId: resEnforceNamingConventionResources.id
        parameters: {
          resourceType: {
            value: 'Microsoft.ManagedIdentity/userAssignedIdentities'
          }
          resourceAbbreviation:{
            value: 'mi'
          }          
        }
      }
      {    
        policyDefinitionReferenceId: 'Enforce-NamingConvention-VNet'    
        policyDefinitionId: resEnforceNamingConventionResources.id
        parameters: {
          resourceType: {
            value: 'Microsoft.Network/virtualNetworks'
          }
          resourceAbbreviation:{
            value: 'vnet'
          }          
        }
      }
      {    
        policyDefinitionReferenceId: 'Enforce-NamingConvention-NSG'    
        policyDefinitionId: resEnforceNamingConventionResources.id
        parameters: {
          resourceType: {
            value: 'Microsoft.Network/networkSecurityGroups'
          }
          resourceAbbreviation:{
            value: 'nsg'
          }          
        }
      }
      {    
        policyDefinitionReferenceId: 'Enforce-NamingConvention-LAW'    
        policyDefinitionId: resEnforceNamingConventionResources.id
        parameters: {
          resourceType: {
            value: 'Microsoft.OperationalInsights/workspaces'
          }
          resourceAbbreviation:{
            value: 'law'
          }          
        }
      }       
    ]
  }
}
