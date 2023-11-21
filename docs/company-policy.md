# Company policy 

- All resources must be deployed into `Norway East`, `Norway West` or `Sweden central` regions. 
- All resource groups must be tagged with the following three tags:
  - Department
  - Owner
  - Environment
- You shouldn't be allowed to create resource groups without these tags.
- All resources under Resource Group should inherit tags from resource group.
- All resources must follow naming convention.
- Resource group must inherit tags from Subscription.
- Virtual Network and Network Security Group (NSG) diagnostic settings must be deployed by policy.
- NSG flow logs and traffic analytics must be deployed by policy.
- All Policy assignment must be prefixed with `[IAC] - ` prefix.