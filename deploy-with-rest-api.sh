#!/bin/bash

# Direct REST API deployment approach
echo "🚀 Starting REST API-based deployment..."

# Get access token
echo "🔐 Getting Azure access token..."
ACCESS_TOKEN=$(curl -s -X POST \
  "https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${AZURE_CLIENT_ID}" \
  -d "client_secret=${AZURE_CLIENT_SECRET}" \
  -d "resource=https://management.azure.com/" | \
  jq -r '.access_token')

if [ "$ACCESS_TOKEN" == "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ Failed to get access token"
  exit 1
fi

echo "✅ Access token obtained"

# Create resource group
echo "🏗️ Creating resource group..."
curl -s -X PUT \
  "https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourcegroups/rg-prodigy1-dev?api-version=2021-04-01" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "location": "eastus",
    "tags": {
      "Environment": "dev",
      "Project": "Prodigy1"
    }
  }' > /dev/null

echo "✅ Resource group created"

# Compile Bicep to ARM
echo "📋 Compiling Bicep template..."
bicep build infrastructure/bicep/main.bicep --outfile /tmp/main.json

# Create parameters for the deployment
echo "📄 Preparing parameters..."
DEPLOYMENT_PARAMS=$(jq -n \
  --arg appName "prodigy1" \
  --arg location "eastus" \
  --arg environment "dev" \
  --argjson template "$(cat /tmp/main.json)" \
  '{
    "properties": {
      "template": $template,
      "parameters": {
        "appName": {"value": $appName},
        "location": {"value": $location},
        "environment": {"value": $environment}
      },
      "mode": "Incremental"
    }
  }')

# Deploy the template
echo "🚀 Deploying infrastructure via REST API..."
DEPLOYMENT_NAME="prodigy1-deployment-$(date +%s)"

DEPLOYMENT_RESPONSE=$(curl -s -X PUT \
  "https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourcegroups/rg-prodigy1-dev/providers/Microsoft.Resources/deployments/${DEPLOYMENT_NAME}?api-version=2021-04-01" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$DEPLOYMENT_PARAMS")

echo "📊 Deployment initiated"

# Wait for deployment to complete
echo "⏳ Waiting for deployment to complete..."
for i in {1..30}; do
  sleep 10
  RESPONSE=$(curl -s -X GET \
    "https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourcegroups/rg-prodigy1-dev/providers/Microsoft.Resources/deployments/${DEPLOYMENT_NAME}?api-version=2021-04-01" \
    -H "Authorization: Bearer $ACCESS_TOKEN")
  
  STATUS=$(echo "$RESPONSE" | jq -r '.properties.provisioningState // "Unknown"')
  
  echo "Status: $STATUS"
  
  # Debug: Print full response if status is Unknown for the first few attempts
  if [ "$STATUS" == "Unknown" ] && [ $i -le 3 ]; then
    echo "Debug response: $RESPONSE" | head -c 500
  fi
  
  if [ "$STATUS" == "Succeeded" ]; then
    echo "✅ Infrastructure deployment completed successfully"
    exit 0
  elif [ "$STATUS" == "Failed" ]; then
    echo "❌ Infrastructure deployment failed"
    # Get error details
    echo "$RESPONSE" | jq '.properties.error // empty'
    exit 1
  fi
done

echo "⏰ Deployment timeout - checking final status..."
FINAL_RESPONSE=$(curl -s -X GET \
  "https://management.azure.com/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourcegroups/rg-prodigy1-dev/providers/Microsoft.Resources/deployments/${DEPLOYMENT_NAME}?api-version=2021-04-01" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

FINAL_STATUS=$(echo "$FINAL_RESPONSE" | jq -r '.properties.provisioningState // "Unknown"')

echo "Final response debug: $FINAL_RESPONSE" | head -c 500

if [ "$FINAL_STATUS" == "Succeeded" ]; then
  echo "✅ Infrastructure deployment completed successfully"
  exit 0
else
  echo "❌ Infrastructure deployment failed or timed out: $FINAL_STATUS"
  if [ "$FINAL_STATUS" == "Failed" ]; then
    echo "$FINAL_RESPONSE" | jq '.properties.error // empty'
  fi
  exit 1
fi
