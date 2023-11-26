# lab-04 - Implement Azure Initiative to group naming convention policy definition for supported resource types

Initiatives enable you to group several related policy definitions to simplify assignments and management because you work with a group as a single item. In our example, we can group related naming convention policy definitions for supported resource types into a single initiative. Rather than assigning each policy individually, we apply the initiative.

## Task #1 - delete `[IAC] - Enforce NamingConvention for Managed Identity` policy assignment

In previous lab, we already created `[IAC] - Enforce NamingConvention for Managed Identity` policy assignment, so let's delete one first.

```powershell
az policy assignment delete -n '[IAC] - Enforce NamingConvention for ResourceGroups'
```

## Task #1 - create initiative definition

Create `policy-definition-set.bicep` file with the following content:

```bicep

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
```	

Deploy `policy-definition-set.bicep` file:

```powershell
az deployment sub create  --template-file policy-definition-set.bicep --location norwayeast
```

Check that initiative definition is created:

```powershell
az policy set-definition show -n 'IAC-Naming-Convention'
```

## Task #2 - assign policy initiative 

Create `naming-convention-assignment.bicep` file with the following content:

```bicep
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
```

Deploy `naming-convention-assignment.bicep` file:

```powershell
az deployment group create --template-file .\naming-convention-assignment.bicep -g iac-ws7-rg
```

Check that policy assignment was created:

```powershell
az policy assignment show -n '[IAC] - Enforce Naming Convention' -g iac-ws7-rg
```

## Task #3 - test policy initiative

