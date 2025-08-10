# Deployment Guide

This guide provides step-by-step instructions for deploying the Prodigy1 application to Azure.

## Prerequisites

- Azure CLI installed and configured
- Azure subscription with appropriate permissions
- Resource groups created for each environment

## Resource Group Setup

Create resource groups for each environment:

```bash
# Development environment
az group create --name "rg-prodigy1-dev" --location "East US"

# Production environment
az group create --name "rg-prodigy1-prod" --location "East US"
```

## Infrastructure Deployment

### 1. Deploy Infrastructure using Bicep

Navigate to the infrastructure directory:
```bash
cd infrastructure/bicep
```

#### Development Environment
```bash
az deployment group create \
  --resource-group "rg-prodigy1-dev" \
  --template-file main.bicep \
  --parameters @parameters.dev.json
```

#### Production Environment
```bash
az deployment group create \
  --resource-group "rg-prodigy1-prod" \
  --template-file main.bicep \
  --parameters @parameters.prod.json
```

### 2. Validate Deployment
```bash
az deployment group validate \
  --resource-group "rg-prodigy1-dev" \
  --template-file main.bicep \
  --parameters @parameters.dev.json
```

## Application Deployment

### Backend (Azure Functions)

1. Build the functions:
```bash
cd backend
npm install
npm run build
```

2. Deploy to Azure:
```bash
func azure functionapp publish prodigy1-dev-funcapp
```

### Frontend (Web App)

1. Build the application:
```bash
cd frontend
npm install
npm run build
```

2. Deploy using Azure CLI:
```bash
az webapp up --name prodigy1-dev-webapp --resource-group rg-prodigy1-dev
```

## Configuration

### Environment Variables

Update the following settings in Azure Portal or via CLI:

#### Function App Settings
- `AZURE_FUNCTIONS_ENVIRONMENT`: Set to appropriate environment
- Any additional custom settings

#### Web App Settings
- `NEXT_PUBLIC_API_BASE_URL`: URL of your Function App
- `NEXT_PUBLIC_ENVIRONMENT`: Environment name

### CORS Configuration

Ensure CORS is properly configured in both:
- Function App host.json
- Azure portal Function App CORS settings

## Monitoring

1. **Application Insights**: Automatically configured during infrastructure deployment
2. **Log Analytics**: Set up for centralized logging
3. **Alerts**: Configure in Azure Monitor for critical metrics

## Troubleshooting

### Common Issues

1. **CORS Errors**: Check Function App CORS configuration
2. **Function Not Found**: Verify function deployment and routing
3. **Environment Variables**: Ensure all required settings are configured

### Debug Commands

```bash
# Check Function App logs
az webapp log tail --name prodigy1-dev-funcapp --resource-group rg-prodigy1-dev

# Check Web App logs
az webapp log tail --name prodigy1-dev-webapp --resource-group rg-prodigy1-dev
```

## Rollback Procedure

If deployment fails or issues are discovered:

1. **Infrastructure**: Redeploy previous Bicep template version
2. **Applications**: Deploy previous application version
3. **Database**: Restore from backup if applicable

## Security Checklist

- [ ] HTTPS enforced on all services
- [ ] Proper CORS configuration
- [ ] Environment variables secured
- [ ] Authentication implemented
- [ ] Resource access properly configured
