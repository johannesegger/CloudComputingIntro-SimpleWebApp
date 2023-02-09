param location string = resourceGroup().location
param repositoryUrl string
param branch string = 'main'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'B1' // List SKUs not implemented: https://github.com/Azure/azure-cli/issues/13466
    capacity: 1
  }
  kind: 'linux'
}

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webapp-${uniqueString(resourceGroup().id)}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0' // az webapp list-runtimes
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: '${webApplication.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'sqlserver-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: 'eggj@htlvb.at'
      sid: '498bc0fb-c2b5-4700-a6a2-f2f8cbe49b88' // az ad user show --id eggj@htlvb.at
      principalType: 'User'
    }
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: 'sqldb-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    capacity: 2
    family: 'Gen5'
    name: 'GP_S_Gen5' // az sql db list-editions -l westeurope -o table
  }
  properties: {
    maxSizeBytes: 2 * 1024 * 1024 * 1024
  }
}

// https://kontext.tech/article/1226/azure-bicep-allow-azure-services-and-resources-to-access-this-resource
resource sqlServerAllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-11-01' = {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
