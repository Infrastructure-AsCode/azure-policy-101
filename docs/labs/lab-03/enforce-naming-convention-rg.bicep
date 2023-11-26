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
