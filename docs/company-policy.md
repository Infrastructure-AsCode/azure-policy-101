# Company policy 

- All resources must be deployed into `Norway East`, `Norway West` or `Sweden central` regions. 
- All resource groups must be tagged with the following three tags:
  - IAC-Department
  - IAC-Owner
- You shouldn't be allowed to create resource groups without these tags.
- All resources under Resource Group should inherit tags from resource group.
- All resources must follow [naming convention](naming-conventions.md).
- Resource group must inherit tags from Subscription.
- Virtual Network and Network Security Group (NSG) diagnostic settings must be deployed by policy.
- All Network Security Groups (NSG) must have flow logs enabled. 
- NSG flow logs must be deployed and configured by Azure policy.
- All Policy Definition, Policy Initiatives, and Policy Assignments must be prefixed with `[IAC] - ` prefix.
