targetScope = 'subscription'

resource resEnforceNamingConventionResource 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Enforce-NamingConvention-Resources'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    displayName: '[IAC] - Enforce naming convention for resources'
    description: 'This policy enforces a naming pattern for resources.'
    metadata: {
      version: '1.0.0'
      category: 'Naming convention'
    }
    parameters: {
      resourceType: {
        type: 'string'
        metadata: {
          displayName: 'Resource type'
          description: 'The resource type to enforce naming convention.'
          strongType: 'resourceType'
        }
      }
      resourceAbbreviation: {
        type: 'string'
        metadata: {
          displayName: 'Resource abbreviation'
          description: 'The resource abbreviation to enforce naming convention.'          
        }        
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: '[parameters(\'resourceType\')]'
          }
          {
            anyOf: [
              {
                field: 'name'
                notLike: '[concat(\'*-\', parameters(\'resourceAbbreviation\'))]'
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
  }
}
