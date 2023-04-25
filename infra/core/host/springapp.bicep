param name string
param location string = resourceGroup().location
param tags object = {}
param relativePath string

resource asaInstance 'Microsoft.AppPlatform/Spring@2022-12-01' = {
  name: name
  location: location
  tags: tags
}

resource asaApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: '${name}-app'
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
  name: 'asa-deployment'
  parent: asaApp
  properties: {
    deploymentSettings: {
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
      type: 'Jar'
      runtimeVersion: 'Java_11'
      relativePath: relativePath
    }
  }
}

output identityPrincipalId string = asaApp.identity.principalId
output name string = asaApp.name
output uri string = 'https://${asaApp.properties.url}'
