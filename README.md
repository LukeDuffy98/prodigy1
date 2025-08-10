# Prodigy1 🚀

A modern web application with an Azure App Service frontend that communicates with Azure Function Apps for backend services, enhanced with GitHub Copilot AI assistance.

## 🤖 AI-Powered Development

This project is configured with **GitHub Copilot Agent** to accelerate development and improve code quality through AI assistance.

### Quick AI Setup
1. **Install VS Code Extensions**: Recommended extensions are configured in `.vscode/extensions.json`
2. **Enable GitHub Copilot**: Ensure you have a Copilot subscription and the extension is active
3. **Read the Guide**: Check out our [Copilot Usage Guide](docs/copilot-usage-guide.md) for best practices

### Copilot Features
- 🧠 **Intelligent Code Generation**: AI-powered suggestions for Azure Functions and React components
- 🔍 **Automated Code Review**: GitHub Actions workflows provide AI-assisted PR reviews
- 📋 **Smart Templates**: Issue and PR templates optimized for Copilot assistance
- 🛠️ **Development Workflows**: Automated tasks for common development scenarios
- 📚 **Comprehensive Documentation**: AI-generated guides and best practices

## Architecture Overview

- **Frontend**: Next.js TypeScript web application hosted on Azure App Service
- **Backend**: Serverless Azure Function Apps providing REST APIs  
- **Communication**: HTTP/HTTPS requests between frontend and backend
- **AI Integration**: GitHub Copilot for development assistance
- **Infrastructure**: Azure cloud services defined with Bicep templates

## Prerequisites

### Development Environment
- Node.js (v18+ recommended)
- Azure CLI
- Azure Functions Core Tools
- Visual Studio Code (recommended)
- Git
- GitHub Copilot subscription

### Azure Requirements
- Azure subscription
- Resource group for the application
- Azure App Service plan
- Azure Function App
- Azure Storage Account (for Function Apps)

## Project Structure

```
prodigy1/
├── frontend/              # Next.js TypeScript web application
│   ├── src/
│   │   ├── pages/        # Next.js pages and API routes
│   │   ├── components/   # React components
│   │   └── services/     # API service layer
│   ├── public/           # Static assets
│   ├── styles/           # CSS styles
│   └── package.json      # Frontend dependencies
├── backend/               # Azure Function Apps
│   ├── functions/        # Individual function endpoints
│   │   ├── getData/      # GET /api/getData
│   │   ├── createData/   # POST /api/createData
│   │   └── health/       # GET /api/health
│   ├── host.json         # Azure Functions host configuration
│   ├── local.settings.json # Local development settings
│   └── package.json      # Backend dependencies
├── infrastructure/       # Azure infrastructure as code
│   └── bicep/           # Azure Bicep templates
│       ├── main.bicep   # Main infrastructure template
│       └── parameters.*.json # Environment parameters
├── docs/                 # Documentation
│   ├── api.md           # API documentation
│   ├── copilot-guide.md # Comprehensive Copilot guide
│   ├── deployment.md    # Deployment guide
│   └── development.md   # Development setup
├── .github/             # GitHub templates and workflows
│   ├── workflows/       # Copilot-enhanced CI/CD
│   └── copilot-instructions.md # AI guidelines
├── start-dev.*          # Local development scripts
└── README.md            # This file
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
- Follow project guidelines in `.github/copilot-instructions.md`

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
3. Use GitHub Copilot for code assistance and reviews
4. Test API integration
5. Commit changes: `git commit -m "Add new feature"`
6. Push branch: `git push origin feature/new-feature`
7. Create pull request using the provided template
8. Deploy to staging environment
9. Test in staging
10. Deploy to production

## Contributing

This project leverages GitHub Copilot for enhanced collaboration:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Use the development scripts for consistent setup
4. Make your changes following the patterns in `docs/copilot-guide.md`
5. Use GitHub Copilot Chat for code assistance and review
6. Test locally using `./start-dev.sh` (or equivalent for your OS)
7. Follow the PR template for comprehensive code reviews
8. Add tests if applicable
9. Submit a pull request

## Documentation

- 📖 [Main README](README.md) - This file, project overview and setup
- 🤖 [Copilot Guide](docs/copilot-guide.md) - Comprehensive guide for GitHub Copilot
- 🤖 [Copilot Usage Guide](docs/copilot-usage-guide.md) - AI-assisted development best practices
- 🤖 [Copilot Instructions](.github/copilot-instructions.md) - Project-specific AI guidelines
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
- **Extensions**: Recommended extensions for Azure development and GitHub Copilot

Use `Ctrl+Shift+P` → "Tasks: Run Task" to access predefined development tasks.

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

## Support

For issues and questions:
- 🤖 **AI Assistance**: Use GitHub Copilot Chat for immediate help
- 📋 Create an issue in this repository using our Copilot-enhanced templates
- 📚 Check the documentation in the `docs/` folder
- 🤖 Refer to `docs/copilot-guide.md` for Copilot-specific guidance
- ☁️ Review Azure Functions and Next.js documentation
- 🔍 Check Azure service health in the Azure portal
- 💬 **Discussions**: Engage in project discussions with AI assistance

## License

[Add your license information here]

---

*This project is enhanced with GitHub Copilot Agent for accelerated, AI-assisted development.*
