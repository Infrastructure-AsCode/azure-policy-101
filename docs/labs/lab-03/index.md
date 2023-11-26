# lab-03 - implement Azure policy to enforce naming convention for your Azure resources


As part of our [company policy](../../company-policy.md), we need to enforce [naming convention](../../naming-conventions.md) for all Azure resources that we provision. It shouldn't be allowed to create resource if its name doesn't follow naming convention. There are no BuiltIn policies that enforce naming convention, so we need to create custom policy.

We can split this task in two parts:
1. Naming convention for resource groups
2. Naming convention for resources

Let's start with resource groups.

## Task #1 - create policy definition to enforce naming convention for resource groups

According to our [naming convention](../../naming-conventions.md), resource group name should start with `iac-` prefix and end with `-rg` suffix. We can create policy definition that will enforce this naming convention.

We will use Bicep to create policy definition. Create `enforce-naming-convention-rg.bicep` file with the following content:

```bicep
targetScope = 'subscription'

resource resEnforceNamingConventionResourceGroup 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Enforce-NamingConvention-ResourceGroup'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    displayName: '[IAC] - Enforce naming convention for resource groups'
    description: 'This policy enforces a naming pattern for resource groups.'
    metadata: {
      version: '1.0.0'
      category: 'Naming convention'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            allOf: [
              {
                field: 'name'
                notLike: 'dashboards'
              }
              {
                field: 'name'
                notLike: 'cloud-shell-storage-*'
              }
            ]
          }
          {
            anyOf: [
              {
                field: 'name'
                notLike: '*-rg'
              }              
              {
                field: 'name'
                notLike: 'iac-*'
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
    parameters: {}
  }
}
```

Let's go through the code block by block.

```bicep
targetScope = 'subscription'
```

We want to apply this policy definition on subscription level, so we set `targetScope` to `subscription`. 

Under properties, we define policy definition name, policy type, mode, display name, description, metadata, parameters and policy rule.

This policy definition doesn't require any parameters.

Policy rule contains three rule sets:
1. If resource type is `Microsoft.Resources/subscriptions/resourceGroups`
2. If resource name doesn't start with `iac-` and doesn't end with `-rg` 
3. If resource name doesn't contain `dashboards` or `cloud-shell-storage-*`

If all three conditions are met, then effect is set to `deny`, which means that resource creation will be denied.

If we translate these rules in plain English, we get the following: 

> "If resource group name doesn't start with `iac-` and doesn't end with `-rg` then deny resource group creation. Don't apply this policy to resource groups that named `dashboards` or `cloud-shell-storage-*`."

The rule 3 is required because we don't want to deny creation of resources groups managed by Azure Portal or Azure Products, like `dashboards` and `cloud-shell-storage-*` resource groups. These resource groups are created by Azure portal and we don't have control over their names. In your environment, you might have other resource groups that you want to exclude from this policy. 

Next, Deploy policy definition by running the following command:

```powershell
az deployment sub create --template-file .\enforce-naming-convention-rg.bicep --location norwayeast
```

You can verify that policy definition was created by running the following command:

```powershell
az policy definition list --query "[?displayName=='[IAC] - Enforce naming convention for resource groups']"
# or 
az policy definition show -n Enforce-NamingConvention-ResourceGroup
```

or you can search it in the portal under `iac-ws7-rg->Settings-Policy->Definitions`. Search for `[IAC] - Enforce naming convention for resource groups` and you should see newly created policy definition.

![policy-definition](../../assets/images/lab-03/pd-search.png)

## Task #2 - create policy assignment for `Enforce-NamingConvention-ResourceGroup` policy using Bicep

Now that we have policy definition, we need to assign it to subscription. We will use Bicep to create policy assignment. Create `enforce-naming-convention-rg-assignment.bicep` file with the following content:

```bicep
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
```

Deploy policy assignment by running the following command:

```powershell
az deployment sub create --template-file .\enforce-naming-convention-rg-assignment.bicep --location norwayeast
```

Check that policy assignment was created:

```powershell
az policy assignment list  --query [].displayName -otsv  
```

## Task #3 - test policy assignment

Let's test policy assignment by creating resource group that doesn't follow naming convention. Run the following command:

```powershell
az group create --name foobar-ws7-test-rg --location norwayeast --tags IAC-Department=foobar
```
It should be denied with the following error message:

```txt
(RequestDisallowedByPolicy) Resource 'foobar-ws7-test-rg' was disallowed by policy. Policy identifiers: '[{"policyAssignment":{"name":"[IAC] - Enforce NamingConvention for ResourceGroups","id":"/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyAssignments/[IAC] - Enforce NamingConvention for ResourceGroups"},"policyDefinition":{"name":"[IAC] - Enforce naming convention for resource groups","id":"/subscriptions/8878beb2-5e5d-4418-81ae-783674eea324/providers/Microsoft.Authorization/policyDefinitions/Enforce-NamingConvention-ResourceGroup"}}]'.`
```

If you look closely to the output, you can also find `evaluationDetails` that shows how policy evaluated policy rules.

Check the last item in the `evaluationDetails` array. If should contain

```json 
 {
    "result": "True",
    "expressionKind": "Field",
    "expression": "name",
    "path": "name",
    "expressionValue": "iac1-ws71-rg",
    "targetValue": "iac-*",
    "operator": "NotLike"
}
```

That means that resource group name `iac1-ws71-rg` doesn't match `iac-*` pattern, so policy evaluation result is `True` and resource creation is denied.

Let's try another test-case. Run the following command:

```powershell
az group create --name iac-ws71-rg1 --location norwayeast --tags IAC-Department=foobar
```

Check the `evaluationDetails` array. 

```json
{
    "result": "True",
    "expressionKind": "Field",
    "expression": "name",
    "path": "name",
    "expressionValue": "iac-ws71-rg1",
    "targetValue": "*-rg",
    "operator": "NotLike"
}
```
The last item now shows that resource group name `iac-ws71-rg1` doesn't match `*-rg` pattern, so policy evaluation result is `True` and resource creation is denied. 

Now, let's test that policy allows resource group name from the exception list. Run the following command:

```powershell
az group create --name cloud-shell-storage-1 --location norwayeast --tags IAC-Department=foobar
```
It should allow resource group creation.

Last test-case. Run the following command:

```powershell
az group create --name iac-ws72-rg --location norwayeast --tags IAC-Department=foobar
```

It should allow resource group creation.
