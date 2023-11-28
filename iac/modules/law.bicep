param parLocation string
param parPrefix string

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${parPrefix}-${uniqueString(resourceGroup().id)}-law'
  location: parLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
