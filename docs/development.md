# Development Setup Guide

This guide will help you set up the development environment for the Prodigy1 application.

## Prerequisites

### Required Software

1. **Node.js** (v18 or higher)
   - Download from [nodejs.org](https://nodejs.org/)
   - Verify installation: `node --version`

2. **Azure CLI**
   - Install from [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - Verify installation: `az --version`

3. **Azure Functions Core Tools**
   ```bash
   npm install -g azure-functions-core-tools@4 --unsafe-perm true
   ```
   - Verify installation: `func --version`

4. **Git**
   - Download from [git-scm.com](https://git-scm.com/)
   - Verify installation: `git --version`

### Recommended Software

1. **Visual Studio Code**
   - Download from [code.visualstudio.com](https://code.visualstudio.com/)
   - Install Azure Functions extension
   - Install Azure App Service extension

2. **Azure Storage Emulator** (for local development)
   - Install Azurite: `npm install -g azurite`

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/LukeDuffy98/prodigy1.git
cd prodigy1
```

### 2. Frontend Setup

```bash
cd frontend
npm install
cp .env.local.example .env.local
# Edit .env.local with your local configuration
npm run dev
```

The frontend will be available at `http://localhost:3000`

### 3. Backend Setup

```bash
cd ../backend
npm install
cp local.settings.json.example local.settings.json
# Edit local.settings.json with your configuration
func start
```

The backend will be available at `http://localhost:7071`

## Development Workflow

### 1. Daily Development

```bash
# Terminal 1 - Frontend
cd frontend
npm run dev

# Terminal 2 - Backend
cd backend
func start

# Terminal 3 - Storage Emulator (if needed)
azurite --silent --location ./azurite --debug ./azurite/debug.log
```

### 2. Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to frontend or backend

3. Test locally:
   - Frontend: `http://localhost:3000`
   - Backend: `http://localhost:7071/api/health`

4. Commit changes:
   ```bash
   git add .
   git commit -m "Add your feature description"
   ```

5. Push branch:
   ```bash
   git push origin feature/your-feature-name
   ```

### 3. Testing API Integration

Use the health endpoint to test connectivity:

```bash
# Test backend health
curl http://localhost:7071/api/health

# Test frontend API call
# Navigate to http://localhost:3000 and check the data loading
```

## Environment Configuration

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
NEXT_PUBLIC_ENVIRONMENT=development
NEXT_PUBLIC_APP_NAME=Prodigy1
```

### Backend (local.settings.json)
```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "WEBSITE_NODE_DEFAULT_VERSION": "~18",
    "CORS_ORIGINS": "http://localhost:3000"
  },
  "Host": {
    "LocalHttpPort": 7071,
    "CORS": "http://localhost:3000"
  }
}
```

## Debugging

### Frontend Debugging

1. **Browser DevTools**: Use Chrome/Edge DevTools for client-side debugging
2. **VS Code**: Configure launch.json for Next.js debugging
3. **Network Tab**: Monitor API calls and responses

### Backend Debugging

1. **VS Code**: Attach to Azure Functions host
2. **Console Logs**: Check terminal output where `func start` is running
3. **Azure Functions Extension**: Use VS Code extension for debugging

### Common Issues

1. **CORS Errors**
   - Check CORS configuration in `host.json`
   - Verify `local.settings.json` CORS settings

2. **Port Conflicts**
   - Frontend default: 3000
   - Backend default: 7071
   - Change ports if needed

3. **Module Not Found**
   - Run `npm install` in respective directories
   - Check import paths and file names

## Database Setup (Future)

When adding database functionality:

1. **Azure Cosmos DB**: For NoSQL data
2. **Azure SQL Database**: For relational data
3. **Local Development**: Use emulators or Docker containers

## Additional Tools

### Optional Development Tools

1. **Postman**: For API testing
2. **Azure Storage Explorer**: For blob storage management
3. **Docker**: For containerized development

### VS Code Extensions

- Azure Functions
- Azure App Service
- Azure Account
- REST Client
- TypeScript and JavaScript Language Features

## Getting Help

1. Check this documentation first
2. Review Azure Functions documentation
3. Check Next.js documentation
4. Create an issue in the repository
5. Check Azure service health status
