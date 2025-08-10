# GitHub Copilot Development Guide for Prodigy1

This document provides comprehensive information for GitHub Copilot to understand and assist with the Prodigy1 project development.

## Project Overview

**Prodigy1** is a modern web application with:
- **Frontend**: Next.js TypeScript application hosted on Azure App Service
- **Backend**: Azure Functions (Node.js/TypeScript) providing REST APIs
- **Infrastructure**: Azure cloud services defined with Bicep templates
- **Architecture**: Frontend calls Azure Function APIs over HTTP/HTTPS

## Quick Start for Development

### Option 1: Use Local Development Scripts (Recommended)

```bash
# For Linux/macOS/Git Bash
./start-dev.sh

# For Windows PowerShell
.\start-dev.ps1

# For Windows Command Prompt
start-dev.bat
```

### Option 2: Manual Startup

```bash
# Terminal 1 - Backend (Azure Functions)
cd backend
npm install
npm run start

# Terminal 2 - Frontend (Next.js)
cd frontend
npm install
npm run dev
```

## Project Structure and Architecture

```
prodigy1/
├── frontend/                 # Next.js TypeScript web application
│   ├── src/
│   │   ├── pages/           # Next.js pages and API routes
│   │   ├── components/      # React components
│   │   └── services/        # API service layer
│   ├── public/              # Static assets
│   ├── styles/              # CSS styles
│   ├── package.json         # Frontend dependencies
│   ├── next.config.js       # Next.js configuration
│   ├── tsconfig.json        # TypeScript configuration
│   └── .env.local           # Environment variables
├── backend/                  # Azure Functions backend
│   ├── functions/           # Individual function endpoints
│   │   ├── getData/         # GET /api/getData
│   │   ├── createData/      # POST /api/createData
│   │   └── health/          # GET /api/health
│   ├── package.json         # Backend dependencies
│   ├── host.json           # Azure Functions host configuration
│   ├── local.settings.json  # Local development settings
│   └── tsconfig.json        # TypeScript configuration
├── infrastructure/          # Infrastructure as Code
│   └── bicep/              # Azure Bicep templates
│       ├── main.bicep      # Main infrastructure template
│       ├── parameters.*.json # Environment parameters
│       └── deploy.ps1      # Deployment scripts
├── docs/                    # Documentation
│   ├── api.md              # API documentation
│   ├── deployment.md       # Deployment guide
│   └── development.md      # Development setup
├── start-dev.*             # Local development scripts
└── README.md               # Main project documentation
```

## Development Guidelines for Copilot

### Frontend Development (Next.js/TypeScript)

**Key Patterns:**
- Use TypeScript for all new files
- Import API service from `@/services/apiService`
- Environment variables prefixed with `NEXT_PUBLIC_` for client-side access
- Components in `src/components/` directory
- Pages in `src/pages/` directory following Next.js file-based routing

**API Integration Pattern:**
```typescript
import { apiService } from '@/services/apiService'

// GET request
const data = await apiService.getData()

// POST request
const result = await apiService.createData(payload)
```

**Environment Variables:**
- `NEXT_PUBLIC_API_BASE_URL`: Azure Functions API base URL
- `NEXT_PUBLIC_ENVIRONMENT`: Current environment (development, staging, production)
- `NEXT_PUBLIC_APP_NAME`: Application name

### Backend Development (Azure Functions/TypeScript)

**Key Patterns:**
- Each function in its own directory under `functions/`
- TypeScript with Azure Functions types
- Consistent error handling and CORS headers
- Environment variables accessed via `process.env`

**Function Structure:**
```typescript
import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('Function executed');
    
    try {
        // Function logic here
        context.res = {
            status: 200,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: responseData
        };
    } catch (error) {
        context.log.error('Error:', error);
        context.res = {
            status: 500,
            body: { error: "Internal server error" }
        };
    }
};

export default httpTrigger;
```

**Function Configuration (function.json):**
```json
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "httpTrigger",
      "direction": "in",
      "name": "req",
      "methods": ["get", "post"]
    },
    {
      "type": "http",
      "direction": "out", 
      "name": "res"
    }
  ]
}
```

## API Endpoints

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| GET | `/api/health` | Health check | None | `{ status, timestamp, version, environment, uptime, checks }` |
| GET | `/api/getData` | Get sample data | None | `{ message, timestamp, environment, requestId }` |
| POST | `/api/createData` | Create new data | `{ name, description, category }` | `{ id, ...inputData, createdAt, status }` |

## Common Development Tasks

### Adding a New API Endpoint

1. **Create function directory**: `backend/functions/newEndpoint/`
2. **Create function.json**: Define HTTP trigger and bindings
3. **Create index.ts**: Implement function logic
4. **Update apiService.ts**: Add client-side method
5. **Test locally**: Verify endpoint works with frontend

### Adding a New Frontend Page

1. **Create page file**: `frontend/src/pages/newpage.tsx`
2. **Implement component**: Use TypeScript and React hooks
3. **Add API integration**: Use `apiService` for backend calls
4. **Update navigation**: Add links in main layout
5. **Test locally**: Verify page renders and functions

### Environment Configuration

**Local Development URLs:**
- Frontend: `http://localhost:3000`
- Backend: `http://localhost:7071`
- API Base: `http://localhost:7071/api`

**Required Environment Files:**
- `frontend/.env.local`: Frontend environment variables
- `backend/local.settings.json`: Azure Functions local settings

## Deployment Information

### Azure Resources Created by Infrastructure

- **Resource Group**: Container for all resources
- **App Service Plan**: Hosting plan for web apps
- **Web App**: Frontend hosting (Azure App Service)
- **Function App**: Backend hosting (Azure Functions)
- **Storage Account**: Required for Azure Functions
- **Application Insights**: Monitoring and logging
- **Log Analytics Workspace**: Centralized logging

### Deployment Commands

```bash
# Infrastructure deployment
cd infrastructure/bicep
az deployment group create --resource-group "rg-prodigy1-dev" --template-file main.bicep --parameters @parameters.dev.json

# Frontend deployment
cd frontend
npm run build
az webapp up --name prodigy1-dev-webapp --resource-group rg-prodigy1-dev

# Backend deployment
cd backend
func azure functionapp publish prodigy1-dev-funcapp
```

## Troubleshooting Common Issues

### CORS Errors
- Check `backend/host.json` CORS configuration
- Verify `local.settings.json` CORS settings
- Ensure frontend URL is in allowed origins

### Function Not Found
- Verify function is deployed correctly
- Check function.json configuration
- Ensure proper route binding

### Environment Variable Issues
- Check `.env.local` file exists and has correct values
- Verify `NEXT_PUBLIC_` prefix for client-side variables
- Restart development server after changes

### Module Resolution Errors
- Run `npm install` in affected directory
- Check TypeScript path mapping in `tsconfig.json`
- Verify import paths are correct

## Security Considerations

- **HTTPS Only**: All production traffic uses HTTPS
- **CORS**: Properly configured for allowed origins
- **Environment Variables**: Sensitive data in Azure Key Vault
- **Authentication**: Function-level keys for API access
- **Input Validation**: Validate all incoming data

## Testing Strategy

- **Local Testing**: Use development scripts to test full stack
- **Unit Tests**: Test individual functions and components
- **Integration Tests**: Test API endpoints with frontend
- **Health Checks**: Monitor `/api/health` endpoint

## Performance Considerations

- **Function Cold Start**: Azure Functions may have cold start delay
- **Connection Pooling**: Reuse database connections
- **Caching**: Implement appropriate caching strategies
- **Bundle Size**: Optimize frontend bundle size

## Monitoring and Logging

- **Application Insights**: Automatic telemetry collection
- **Function Logs**: Available in Azure portal
- **Console Logging**: Use `context.log()` in functions
- **Error Tracking**: Centralized error logging

This guide provides GitHub Copilot with comprehensive context to assist with Prodigy1 development tasks, code generation, debugging, and architectural decisions.
