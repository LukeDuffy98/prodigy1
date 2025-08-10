// Main Bicep template for Prodigy1 application
@description('The name of the application')
param appName string = 'prodigy1'

@description('The location for all resources')
param location string = resourceGroup().location

@description('The environment name (dev, staging, prod)')
param environment string = 'dev'

@description('The SKU for the App Service Plan')
param appServicePlanSku string = 'F1'

@description('The runtime stack for the web app')
param webAppRuntime string = 'NODE|18-lts'

// Variables
var resourcePrefix = '${appName}-${environment}'
var storageAccountName = '${replace(resourcePrefix, '-', '')}storage'
var appServicePlanName = '${resourcePrefix}-asp'
var webAppName = '${resourcePrefix}-webapp'
var functionAppName = '${resourcePrefix}-funcapp'
var applicationInsightsName = '${resourcePrefix}-ai'
var logAnalyticsWorkspaceName = '${resourcePrefix}-law'

// Storage Account for Azure Functions
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanSku == 'F1' ? 'Free' : 'Standard'
  }
  properties: {
    reserved: true // Required for Linux plans
  }
}

// Web App (Frontend)
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: webAppRuntime
      appSettings: [
        {
          name: 'NEXT_PUBLIC_API_BASE_URL'
          value: 'https://${functionApp.properties.defaultHostName}/api'
        }
        {
          name: 'NEXT_PUBLIC_ENVIRONMENT'
          value: environment
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
      ]
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

// Function App (Backend)
resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'Node|18'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: '${functionAppName}-content'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'AZURE_FUNCTIONS_ENVIRONMENT'
          value: environment
        }
      ]
      cors: {
        allowedOrigins: [
          'https://${webApp.properties.defaultHostName}'
          'http://localhost:3000' // For local development
        ]
        supportCredentials: false
      }
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

// Outputs
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
output storageAccountName string = storageAccount.name
output applicationInsightsName string = applicationInsights.name
output resourceGroupName string = resourceGroup().name
