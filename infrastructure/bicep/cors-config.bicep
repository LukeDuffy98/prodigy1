// CORS configuration template to be applied after main deployment
@description('The name of the application')
param appName string = 'prodigy1'

@description('The environment name (dev, staging, prod)')
param environment string = 'dev'

// Variables
var resourcePrefix = '${appName}-${environment}'
var webAppName = '${resourcePrefix}-webapp'
var functionAppName = '${resourcePrefix}-funcapp'

// Reference existing Function App
resource functionApp 'Microsoft.Web/sites@2022-09-01' existing = {
  name: functionAppName
}

// Reference existing Web App
resource webApp 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webAppName
}

// Configure CORS for Function App
resource functionAppConfig 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'web'
  parent: functionApp
  properties: {
    cors: {
      allowedOrigins: [
        'https://${webApp.properties.defaultHostName}'
        'http://localhost:3000' // For local development
      ]
      supportCredentials: false
    }
  }
}

// Output the configured URLs
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
