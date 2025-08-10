# Prodigy1

A modern web application with an Azure App Service frontend that communicates with Azure Function Apps for backend services.

## Architecture Overview

- **Frontend**: Web application hosted on Azure App Service
- **Backend**: Serverless Azure Function Apps providing REST APIs
- **Communication**: HTTP/HTTPS requests between frontend and backend

## Prerequisites

### Development Environment
- Node.js (v18+ recommended)
- Azure CLI
- Azure Functions Core Tools
- Visual Studio Code (recommended)
- Git

### Azure Requirements
- Azure subscription
- Resource group for the application
- Azure App Service plan
- Azure Function App
- Azure Storage Account (for Function Apps)

## Project Structure

```
prodigy1/
├── frontend/           # Web frontend application
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
├── backend/            # Azure Function Apps
│   ├── functions/
│   ├── host.json
│   ├── local.settings.json
│   └── ...
├── infrastructure/     # Azure infrastructure as code
│   ├── bicep/
│   └── arm/
└── docs/              # Additional documentation
```

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/LukeDuffy98/prodigy1.git
cd prodigy1
```

### 2. Quick Start with Development Scripts (Recommended)

We provide automated scripts to start both frontend and backend services:

```bash
# For Linux/macOS/Git Bash
./start-dev.sh

# For Windows PowerShell  
.\start-dev.ps1

# For Windows Command Prompt
start-dev.bat
```

These scripts will:
- ✅ Check prerequisites (Node.js, Azure Functions Core Tools)
- ✅ Install dependencies automatically
- ✅ Create environment files from templates
- ✅ Start both frontend and backend services
- ✅ Provide helpful status messages and URLs

### 3. Manual Setup (Alternative)

#### Frontend Setup
```bash
cd frontend
npm install
npm run dev
```
The frontend will be available at `http://localhost:3000`

#### Backend Setup (Azure Functions)
```bash
cd backend
npm install
func start
```
The Function App will be available at `http://localhost:7071`

### 4. Environment Configuration

Environment files will be created automatically by the development scripts, or you can create them manually:

**Frontend (.env.local)**
```
NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
NEXT_PUBLIC_ENVIRONMENT=development
```

**Backend (local.settings.json)**
```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "CORS_ORIGINS": "http://localhost:3000"
  }
}
```

## GitHub Copilot Integration

This project is optimized for GitHub Copilot assistance. See the [Copilot Guide](docs/copilot-guide.md) for:
- 🤖 Project structure and patterns for Copilot
- 🔧 Common development tasks and code examples
- 📚 API documentation and endpoint patterns
- 🐛 Troubleshooting guides and solutions
- 🚀 Deployment and infrastructure information

**Quick Copilot Tips:**
- Use the development scripts for consistent local setup
- Check `docs/copilot-guide.md` for comprehensive project context
- API service patterns are in `frontend/src/services/apiService.ts`
- Function templates are in `backend/functions/` directories

## API Integration

### Frontend to Backend Communication

The frontend communicates with Azure Function Apps through HTTP requests:

```javascript
// Example API call from frontend
const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL;

const fetchData = async () => {
  try {
    const response = await fetch(`${apiBaseUrl}/getData`);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('API call failed:', error);
  }
};
```

### Azure Function Example

```javascript
// Example Azure Function
module.exports = async function (context, req) {
  context.log('JavaScript HTTP trigger function processed a request.');
  
  const responseMessage = {
    message: "Hello from Azure Functions!",
    timestamp: new Date().toISOString()
  };

  context.res = {
    status: 200,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"
    },
    body: responseMessage
  };
};
```

## Deployment

### Frontend Deployment (Azure App Service)

1. Build the application:
```bash
cd frontend
npm run build
```

2. Deploy to Azure App Service:
```bash
az webapp up --name your-app-name --resource-group your-rg --runtime "NODE|18-lts"
```

### Backend Deployment (Azure Function App)

1. Deploy functions:
```bash
cd backend
func azure functionapp publish your-function-app-name
```

2. Configure application settings in Azure portal or via CLI:
```bash
az functionapp config appsettings set --name your-function-app-name --resource-group your-rg --settings "SETTING_NAME=value"
```

## Configuration

### CORS Configuration
Ensure your Azure Function App allows requests from your frontend domain:

```json
{
  "cors": {
    "allowedOrigins": [
      "https://your-frontend-domain.azurewebsites.net",
      "http://localhost:3000"
    ]
  }
}
```

### Environment Variables

**Production Frontend Environment Variables:**
- `NEXT_PUBLIC_API_BASE_URL`: Your Azure Function App URL
- `NEXT_PUBLIC_ENVIRONMENT`: production

**Production Backend Settings:**
- `AzureWebJobsStorage`: Azure Storage connection string
- `FUNCTIONS_WORKER_RUNTIME`: node
- Custom application settings as needed

## Security Considerations

1. **Authentication**: Implement Azure AD B2C or other auth providers
2. **API Keys**: Use Azure Function App keys for API protection
3. **CORS**: Configure proper CORS policies
4. **HTTPS**: Ensure all communication uses HTTPS in production
5. **Environment Variables**: Store sensitive data in Azure Key Vault

## Monitoring and Logging

- **Application Insights**: Enable for both frontend and backend
- **Azure Monitor**: Set up alerts and dashboards
- **Function App Logs**: Monitor function execution and errors

## Development Workflow

1. Create feature branch: `git checkout -b feature/new-feature`
2. Develop locally with both frontend and backend running
3. Test API integration
4. Commit changes: `git commit -m "Add new feature"`
5. Push branch: `git push origin feature/new-feature`
6. Create pull request
7. Deploy to staging environment
8. Test in staging
9. Deploy to production

## Troubleshooting

### Common Issues

1. **CORS Errors**: Check CORS configuration in Function App
2. **Function Not Found**: Verify function deployment and routing
3. **Environment Variables**: Ensure all required settings are configured
4. **Connection Issues**: Check network security groups and firewall rules

### Debug Mode

Enable debug logging in your Function App:
```json
{
  "logging": {
    "logLevel": {
      "default": "Debug"
    }
  }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Use the development scripts for consistent setup
4. Make your changes following the patterns in `docs/copilot-guide.md`
5. Test locally using `./start-dev.sh` (or equivalent for your OS)
6. Add tests if applicable
7. Submit a pull request

## Documentation

- 📖 [Main README](README.md) - This file, project overview and setup
- 🤖 [Copilot Guide](docs/copilot-guide.md) - Comprehensive guide for GitHub Copilot
- 🔧 [Development Setup](docs/development.md) - Detailed development environment setup
- 📡 [API Documentation](docs/api.md) - REST API endpoints and examples
- 🚀 [Deployment Guide](docs/deployment.md) - Step-by-step deployment instructions

## Development Scripts

| Script | Platform | Description |
|--------|----------|-------------|
| `start-dev.sh` | Linux/macOS/Git Bash | Full development environment startup |
| `start-dev.ps1` | Windows PowerShell | Full development environment startup |
| `start-dev.bat` | Windows Command Prompt | Full development environment startup |

All scripts automatically:
- ✅ Check prerequisites and install if needed
- ✅ Install npm dependencies
- ✅ Create environment files from templates
- ✅ Start both frontend and backend services
- ✅ Provide status updates and helpful URLs

## VSCode Integration

The project includes VSCode configuration for optimal development:
- **Tasks**: Predefined tasks for building and running services
- **Launch Configurations**: Debug configurations for full-stack debugging
- **Settings**: Optimized settings for TypeScript and Azure Functions development
- **Extensions**: Recommended extensions for Azure development

Use `Ctrl+Shift+P` → "Tasks: Run Task" to access predefined development tasks.

## Support

For issues and questions:
- 📋 Create an issue in this repository  
- 📚 Check the documentation in the `docs/` folder
- 🤖 Refer to `docs/copilot-guide.md` for Copilot-specific guidance
- ☁️ Review Azure Functions and Next.js documentation
- 🔍 Check Azure service health in the Azure portal

## License

[Add your license information here]
