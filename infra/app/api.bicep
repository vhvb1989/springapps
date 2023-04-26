param name string
param location string = resourceGroup().location
param tags object = {}
param relativePath string
param keyVaultName string
param serviceName string = 'todo-api'

module api '../core/host/springapp.bicep' = {
  name: '${name}-app-module'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    relativePath: relativePath
    keyVaultName: keyVaultName
  }
}

output SERVICE_API_IDENTITY_PRINCIPAL_ID string = api.outputs.identityPrincipalId
output SERVICE_API_NAME string = api.outputs.name
output SERVICE_API_URI string = api.outputs.uri
