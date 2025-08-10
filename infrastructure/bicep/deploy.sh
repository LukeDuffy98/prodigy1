# Deploy to Development Environment
az deployment group create \
  --resource-group "rg-prodigy1-dev" \
  --template-file main.bicep \
  --parameters @parameters.dev.json

# Deploy to Production Environment
az deployment group create \
  --resource-group "rg-prodigy1-prod" \
  --template-file main.bicep \
  --parameters @parameters.prod.json

# Validate template before deployment
az deployment group validate \
  --resource-group "rg-prodigy1-dev" \
  --template-file main.bicep \
  --parameters @parameters.dev.json
