# Azure CI/CD Setup Guide

This guide will help you configure the automated deployment pipeline for your Prodigy1 application.

## Prerequisites

1. **Azure Subscription**: You need an active Azure subscription
2. **Azure CLI**: Install from [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. **GitHub Repository**: Your code should be in a GitHub repository

## Step 1: Create Azure Service Principal

The CI/CD pipeline needs permission to deploy resources to Azure. We'll create a service principal with the necessary permissions.

### 1.1 Login to Azure CLI

```bash
az login
```

### 1.2 Set Your Subscription

```bash
# List available subscriptions
az account list --output table

# Set the subscription you want to use
az account set --subscription "Your-Subscription-ID"
```

### 1.3 Create Service Principal

```bash
# Create service principal with Contributor role
az ad sp create-for-rbac \
  --name "prodigy1-github-actions" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
```

**Important**: Save the JSON output - you'll need it for GitHub secrets!

Example output:
```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

## Step 2: Configure GitHub Secrets

Navigate to your GitHub repository and add the following secrets:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these secrets:

### Required Secrets

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `AZURE_CREDENTIALS` | Complete JSON output from Step 1.3 | Service principal credentials for Azure deployment |

### Example AZURE_CREDENTIALS Secret

```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

## Step 3: Configure Environments (Optional but Recommended)

For production deployments, set up GitHub environments with protection rules:

1. Go to **Settings** → **Environments**
2. Create environments: `dev`, `staging`, `prod`
3. For `prod` environment:
   - Add **Required reviewers** (yourself or team members)
   - Add **Wait timer** (e.g., 5 minutes)
   - Add **Environment secrets** if needed

## Step 4: Update Configuration Files

### 4.1 Review Bicep Parameters

Check the parameter files in `infrastructure/bicep/`:
- `parameters.dev.json` - Development environment settings
- `parameters.prod.json` - Production environment settings (create if needed)

Update these files with your preferred Azure region and resource naming:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanSku": {
      "value": "F1"
    },
    "storageAccountType": {
      "value": "Standard_LRS"
    }
  }
}
```

### 4.2 Verify Workflow Configuration

Check `.github/workflows/` files and ensure:
- Resource group names match your preferences
- Azure regions are correct
- App names are unique globally

## Step 5: Test the Deployment

### 5.1 Infrastructure Deployment

1. Go to **Actions** in your GitHub repository
2. Select **Infrastructure Management** workflow
3. Click **Run workflow**
4. Choose:
   - **Action**: `deploy`
   - **Environment**: `dev`
   - **Force**: `false`
5. Click **Run workflow**

### 5.2 Application Deployment

After infrastructure is deployed:

1. Select **Azure Deploy** workflow
2. Click **Run workflow**
3. Choose environment: `dev`
4. Click **Run workflow**

## Step 6: Verify Deployment

After successful deployment, you should have:

1. **Resource Group**: `rg-prodigy1-dev` (or your chosen name)
2. **Web App**: Frontend application accessible via Azure URL
3. **Function App**: Backend API accessible via Azure URL
4. **Storage Account**: For static assets and data
5. **Application Insights**: For monitoring and telemetry

## Available Workflows

### 1. Azure Deploy (`azure-deploy.yml`)
- **Trigger**: Manual workflow dispatch
- **Purpose**: Deploy application code to existing infrastructure
- **Stages**: Infrastructure → Backend → Frontend → Health Check
- **Environments**: dev, staging, prod

### 2. Build and Test (`build-test.yml`)
- **Trigger**: Pull requests to main branch
- **Purpose**: Quality assurance and testing
- **Checks**: Lint, Build, Test, Security Scan, Performance Test

### 3. Infrastructure Management (`infrastructure.yml`)
- **Trigger**: Manual workflow dispatch
- **Purpose**: Manage Azure infrastructure
- **Actions**: deploy, destroy, validate
- **Safety**: Requires force flag for destruction

## Troubleshooting

### Common Issues

1. **Service Principal Permissions**
   ```bash
   # If deployment fails, check service principal has correct permissions
   az role assignment list --assignee YOUR_CLIENT_ID --output table
   ```

2. **Resource Naming Conflicts**
   - App Service names must be globally unique
   - Update app names in workflow files if needed

3. **Subscription Limits**
   - Free tier Azure subscriptions have resource limits
   - Consider upgrading for production workloads

4. **CORS Issues**
   - The workflows automatically configure CORS
   - Manual configuration may be needed for custom domains

### Debugging Steps

1. **Check Workflow Logs**: Review the detailed logs in GitHub Actions
2. **Azure Portal**: Verify resources were created correctly
3. **Function App Logs**: Check Azure Function logs for runtime issues
4. **App Service Logs**: Review Web App deployment and runtime logs

## Next Steps

1. **Custom Domain**: Configure custom domains for production
2. **SSL Certificates**: Set up SSL/TLS certificates
3. **Monitoring**: Configure alerts and monitoring dashboards
4. **Backup**: Set up backup policies for critical data
5. **Security**: Review security settings and enable additional protections

## Security Best Practices

1. **Rotate Secrets**: Regularly rotate service principal secrets
2. **Least Privilege**: Review and minimize service principal permissions
3. **Environment Protection**: Use GitHub environment protection rules
4. **Secret Scanning**: Enable GitHub secret scanning
5. **Dependency Updates**: Keep dependencies updated

## Support

If you encounter issues:

1. Check the workflow logs in GitHub Actions
2. Review Azure deployment logs in the Azure Portal
3. Consult the Azure documentation
4. Check GitHub repository issues for known problems

## Resources

- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)
- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)
