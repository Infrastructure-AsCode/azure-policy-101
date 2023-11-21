# lab-02 - assign `Require a tag on resource groups` and `Require a tag on resources` deny policies to `iac-ws7-rg` resource group

According to our [company policies](../../company-policy.md), all our resources must have a `Department` tag. 

Azure already provides a policy definition called [Require a tag on resource groups](https://www.azadvertizer.net/azpolicyadvertizer/96670d01-0a4d-4649-9c89-2d3abc0a5025.html) and [Require a tag on resources](https://www.azadvertizer.net/azpolicyadvertizer/871b6d14-10aa-478d-b590-94f262ecfa99.html) for this purpose. We just need to assign them to the scope of `iac-ws7-rg` resource group. 
Both policies require one parameter called `tagName` and both use policy effect `deny`, which means that if the policy is not compliant, the resource creation will be denied. 

## Task #1 - Assign `Require a tag on resource groups` policy to the scope of `iac-ws7-rg` resource group using Azure portal

!!! info "Note"
    When you assign Azure policy, you need to decide to what scope you want to assign it to. You can assign policy to Management Group, Subscription or Resource group scope. In our case, we will assign all policies to the scope of `iac-ws7-rg` resource group.

Navigate to the `Settings->Policies` tab of your `iac-ws7-rg` resource group.

![01](../../assets/images/lab-02/assign1.png)

Then click on `Assign policy` button.

![01](../../assets/images/lab-02/assign2.png)

On the `Basic` tab, check that scope is set to `YOU-SUBSCRIPTION-NAME/iac-ws7-rg` and click on `Policy definition search` box.

![01](../../assets/images/lab-02/assign3.png)

On the `Available Definitions` search tab, you can either seach by name or by Policy Definition ID. The best resource to find Policy Definition ID is [azadvertizer.net](https://www.azadvertizer.net/azpolicyadvertizer_all.html).

Enter `Require a tag on resource groups` in the search box and click `Add`.

![01](../../assets/images/lab-02/assign4.png)

This policy assignment will require that `Department` tags is present,and we want to follow our naming conventions, so let's call this assignment `[IAC] - Require a Department tag on resource groups` and goto `Parameters` tab.

![01](../../assets/images/lab-02/assign5.png)

This policy definition requires one parameter called `tagName`. Enter `Department` in the `Tag Name` box and click `Review + create`, check that everything looks good, and click `Create`. If there are any validation errors, fix them and try again.

![01](../../assets/images/lab-02/assign6.png)

After assignments are cerated, you can always find them under `Assignments` tab. Navigate to `Settings->Policies` tab of your `iac-ws7-rg` resource group and click on `Assignments` tab.

![01](../../assets/images/lab-02/assign7.png)

You should now see your newly created policy assignment.


## Task #2 - Assign `Require a tag on resources` policy to `iac-ws7-rg` resource group using `az cli`

Now, let's create new policy assignment for [Require a tag on resources](https://www.azadvertizer.net/azpolicyadvertizer/871b6d14-10aa-478d-b590-94f262ecfa99.html) policy, using `az cli`. 

This policy assignment will require that `Department` tags is present for all resources, and we want to follow our naming conventions, so we call this assignment `[IAC] - Require Department tag on resources`.

[az policy assignment create](https://learn.microsoft.com/en-us/cli/azure/policy/assignment?view=azure-cli-latest#az-policy-assignment-create) command requires the following parameters:

- `--name` - name of the policy assignment
- `--resource-group` - the resource group where the policy will be applied. In our case, it is `iac-ws7-rg`
- `--policy` - policy name or definition ID
- `--params` - JSON formatted string with parameter values of the policy rule. In our case, we need to provide `tagName` parameter with value `Department`.


```powershell
# Create new policy assignment
az policy assignment create --name "[IAC] - Require Department tag on resources" --display-name "[IAC] - Require Department tag on resources" --resource-group "iac-ws7-rg" --policy "871b6d14-10aa-478d-b590-94f262ecfa99" --params '{\"tagName\": { \"value\": \"Department\"}}'
```

Now let's check if the policy was created successfully.

```powershell
# Get all policy assignments for iac-ws7-rg resource group
az policy assignment list -g iac-ws7-rg --query [].displayName -otsv
```

## Task #3 - Test policy

Let's try to create a storage account without `Department` tag and check if the policy is working as expected.

```powershell
az storage account create -g iac-ws7-rg -n safoobartest
```

You should see an error message similar to this one:

```json
(RequestDisallowedByPolicy) Resource 'safoobartest' was disallowed by policy. Policy identifiers: '[{"policyAssignment":{"name":"[IAC] - Require a Department tag on resources","id":"/subscriptions/.../resourceGroups/iac-ws7-rg/providers/Microsoft.Authorization/policyAssignments/1eb584cf0b424c739d8b6ddd"},"policyDefinition":{"name":"Require a tag on resources","id":"/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"}}]'.
```

As you can see, the creation of storage account was denied.

## Task #3 - Check compliance score

Navigate to `Settings->Policies` tab of your `iac-ws7-rg` resource group.

![01](../../assets/images/lab-02/complience-0.png)

Then click on `Compliance` tab, enter `iac` in the `Search` box and see the compliance score.

![01](../../assets/images/lab-02/complience-1.png)

At the moment, the compliance score is 0%. The `[IAC] - Require a Department tag on resources` policy shows that there are 4 non complaint resources and `[IAC] - Require a Department tag on resources` shows that there is one non complaint resource group.

