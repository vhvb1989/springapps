param name string
param location string = resourceGroup().location
param tags object = {}
param relativePath string
param keyVaultName string

resource asaInstance 'Microsoft.AppPlatform/Spring@2022-12-01' = {
  name: name
  location: location
  tags: tags
}

resource asaApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: 'todo-api'
  location: location
  parent: asaInstance
  identity: {
      type: 'SystemAssigned'
    }
  properties: {
    public: true
  }
}

resource asaDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: asaApp
  properties: {
    deploymentSettings: {
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
      environmentVariables: {
        AZURE_KEY_VAULT_ENDPOINT: keyVault.properties.vaultUri
      }
    }
    source: {
      type: 'Jar'
      runtimeVersion: 'Java_17'
      relativePath: relativePath
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (!(empty(keyVaultName))) {
  name: keyVaultName
}

output identityPrincipalId string = asaApp.identity.principalId
output name string = asaApp.name
output uri string = asaApp.properties.url
