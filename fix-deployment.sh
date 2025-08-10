#!/bin/bash

# Quick fix for Azure CLI deployment
echo "🚀 Deploying infrastructure..."

# Use simple approach with output suppression
az deployment group create \
  --resource-group "rg-prodigy1-dev" \
  --template-file "infrastructure/bicep/main.bicep" \
  --parameters @infrastructure/bicep/parameters.dev.json \
  --parameters appName=prodigy1 location=eastus environment=dev \
  --output none \
  --only-show-errors || true

# Wait and verify
sleep 15

echo "🔍 Verifying deployment..."
WEB_APP_COUNT=$(az webapp list --resource-group "rg-prodigy1-dev" --query "length([?name=='prodigy1-dev-webapp'])" --output tsv)
FUNC_APP_COUNT=$(az functionapp list --resource-group "rg-prodigy1-dev" --query "length([?name=='prodigy1-dev-funcapp'])" --output tsv)

if [ "$WEB_APP_COUNT" -gt 0 ] && [ "$FUNC_APP_COUNT" -gt 0 ]; then
  echo "✅ Infrastructure deployment verified successfully"
  exit 0
else
  echo "❌ Infrastructure deployment failed"
  exit 1
fi
