#!/usr/bin/env pwsh

# PowerShell alternative deployment script
Write-Host "🚀 Starting PowerShell-based deployment..." -ForegroundColor Green

# Set error action
$ErrorActionPreference = "Stop"

try {
    # Connect to Azure using service principal
    $clientId = $env:AZURE_CLIENT_ID
    $clientSecret = $env:AZURE_CLIENT_SECRET | ConvertTo-SecureString -AsPlainText -Force
    $tenantId = $env:AZURE_TENANT_ID
    $subscriptionId = $env:AZURE_SUBSCRIPTION_ID
    
    $credential = New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)
    Connect-AzAccount -ServicePrincipal -Credential $credential -TenantId $tenantId -SubscriptionId $subscriptionId
    
    Write-Host "✅ Connected to Azure successfully" -ForegroundColor Green
    
    # Deploy the template
    Write-Host "🏗️ Deploying Bicep template..." -ForegroundColor Yellow
    
    $deploymentResult = New-AzResourceGroupDeployment `
        -ResourceGroupName "rg-prodigy1-dev" `
        -TemplateFile "infrastructure/bicep/main.bicep" `
        -TemplateParameterFile "infrastructure/bicep/parameters.dev.json" `
        -appName "prodigy1" `
        -location "eastus" `
        -environment "dev" `
        -Verbose
    
    if ($deploymentResult.ProvisioningState -eq "Succeeded") {
        Write-Host "✅ Infrastructure deployment completed successfully" -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "❌ Infrastructure deployment failed: $($deploymentResult.ProvisioningState)" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "❌ PowerShell deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
