# Prodigy1 - Azure App Service & Functions Application

**ALWAYS follow these instructions first and only fallback to search or additional context gathering if the information here is incomplete or found to be in error.**

Prodigy1 is planned as an Azure-based application with an App Service frontend and Azure Functions backend. The repository is currently in early development stage with minimal content.

## Current Repository State

**CRITICAL**: This repository is in early development stage and currently contains only documentation. No source code, build scripts, or deployment configurations exist yet.

Current structure:
- `README.md` - Basic project description
- `.github/copilot-instructions.md` - This file

## Working Effectively

### Environment Requirements
The following tools are available and validated in the development environment:
- **Git**: Version 2.50.1 - `git --version`
- **Node.js**: Version 20.19.4 - `node --version`
- **npm**: Version 10.8.2 - `npm --version`  
- **Azure CLI**: Version 2.75.0 - `az --version`
- **dotnet**: Version 8.0.118 - `dotnet --version`
- **curl**: Version 8.5.0 - `curl --version`

### Repository Setup
- Clone the repository: `git clone https://github.com/LukeDuffy98/prodigy1.git`
- Navigate to directory: `cd prodigy1`
- Check current state: `ls -la` (currently shows only README.md and .github/)

### Development Setup (Future)
When the application is developed, expect the following structure and commands:

#### Frontend (Azure App Service)
- Likely Node.js/React application
- Setup commands will include:
  - `npm install` - Install dependencies (NEVER CANCEL: may take 5-10 minutes)
  - `npm run build` - Build frontend (NEVER CANCEL: may take 10-15 minutes, set timeout to 30+ minutes)
  - `npm run dev` - Start development server
  - `npm run test` - Run frontend tests (NEVER CANCEL: may take 5-10 minutes, set timeout to 20+ minutes)

#### Backend (Azure Functions)
- Likely .NET-based Azure Functions
- Setup commands will include:
  - `dotnet restore` - Restore .NET packages (NEVER CANCEL: may take 5-10 minutes)
  - `dotnet build` - Build functions (NEVER CANCEL: may take 5-15 minutes, set timeout to 30+ minutes)
  - `dotnet test` - Run backend tests (NEVER CANCEL: may take 5-10 minutes, set timeout to 20+ minutes)
  - `func start` - Start Azure Functions locally (requires Azure Functions Core Tools)

### Azure Integration Commands
- Login to Azure: `az login`
- List subscriptions: `az account list`
- Set subscription: `az account set --subscription <subscription-id>`
- Deploy app service: `az webapp deploy --resource-group <rg> --name <app-name>`
- Deploy functions: `func azure functionapp publish <function-app-name>`

## Validation Requirements

### Current State Validation
Since no application code exists yet:
1. Verify repository structure: `ls -la`
2. Check git status: `git status`
3. Validate tools are available: `node --version && npm --version && az --version && dotnet --version`

### Future Application Validation
When application code is developed, ALWAYS perform these validation steps after making changes:

#### Frontend Validation
1. Build succeeds: `npm run build` (NEVER CANCEL: set timeout to 30+ minutes)
2. Tests pass: `npm run test` (NEVER CANCEL: set timeout to 20+ minutes)
3. Development server starts: `npm run dev`
4. Navigate to `http://localhost:3000` (or configured port)
5. Verify UI loads and basic functionality works

#### Backend Validation  
1. Build succeeds: `dotnet build` (NEVER CANCEL: set timeout to 30+ minutes)
2. Tests pass: `dotnet test` (NEVER CANCEL: set timeout to 20+ minutes)
3. Functions start locally: `func start`
4. Test API endpoints with curl or HTTP client
5. Verify functions respond correctly

#### Integration Validation
1. Start both frontend and backend simultaneously
2. Test API calls from frontend to backend
3. Verify end-to-end functionality
4. Check Azure deployment readiness with `az webapp validate` or similar

## Critical Timing and Timeout Guidance

**NEVER CANCEL long-running operations.** Azure and .NET builds can be time-intensive:

- **npm install**: 5-10 minutes typical (set timeout: 20+ minutes)
- **npm run build**: 10-15 minutes typical (set timeout: 30+ minutes)  
- **npm run test**: 5-10 minutes typical (set timeout: 20+ minutes)
- **dotnet restore**: 5-10 minutes typical (set timeout: 20+ minutes)
- **dotnet build**: 5-15 minutes typical (set timeout: 30+ minutes)
- **dotnet test**: 5-10 minutes typical (set timeout: 20+ minutes)
- **Azure deployments**: 10-30 minutes typical (set timeout: 60+ minutes)

**ALWAYS wait for commands to complete fully before proceeding.**

## Development Workflow

### Creating New Features
1. Create feature branch: `git checkout -b feature/feature-name`
2. Make changes to appropriate frontend or backend code
3. Run local builds and tests (with proper timeouts)
4. Test functionality manually through UI and API
5. Commit changes: `git add . && git commit -m "descriptive message"`
6. Push and create PR: `git push origin feature/feature-name`

### Code Quality Checks (When Implemented)
- Frontend linting: `npm run lint`
- Backend formatting: `dotnet format`
- Security scanning: `npm audit` or `dotnet list package --vulnerable`
- Dependency updates: `npm update` or `dotnet outdated`

## Azure Deployment

### App Service Deployment
```bash
# Build frontend
npm run build

# Deploy to Azure App Service
az webapp deploy --resource-group <resource-group> --name <app-name> --src-path <build-folder>
```

### Functions Deployment
```bash
# Build functions
dotnet build --configuration Release

# Deploy to Azure Functions
func azure functionapp publish <function-app-name>
```

## Troubleshooting

### Common Issues
- **Build timeouts**: Increase timeout values, never cancel builds
- **Node module issues**: Delete `node_modules` and run `npm install` again
- **.NET restore issues**: Clear NuGet cache with `dotnet nuget locals all --clear`
- **Azure CLI auth**: Run `az login` and verify subscription with `az account show`
- **Functions runtime**: Ensure Azure Functions Core Tools installed with `func --version`

### Environment Setup Issues
- **Missing tools**: Use package managers to install missing dependencies
- **Version conflicts**: Check tool versions match project requirements
- **Azure permissions**: Verify Azure subscription access and resource group permissions

## Important File Locations (Future)

When the application is developed, key files will likely include:
- `package.json` - Frontend dependencies and scripts
- `*.csproj` - .NET project files for Azure Functions
- `host.json` - Azure Functions configuration
- `local.settings.json` - Local development settings (not committed)
- `azure-pipelines.yml` or `.github/workflows/` - CI/CD configuration
- `web.config` or `appsettings.json` - Application configuration

## Quick Reference Commands

```bash
# Repository status
git status
ls -la

# Tool versions
node --version && npm --version && az --version && dotnet --version

# Future build commands (when implemented)
npm install && npm run build  # Frontend
dotnet restore && dotnet build  # Backend

# Future test commands (when implemented)  
npm run test  # Frontend tests
dotnet test   # Backend tests

# Azure login and deployment (when implemented)
az login
az account set --subscription <id>
az webapp deploy --resource-group <rg> --name <app>
func azure functionapp publish <function-app>
```

## Repository Structure (Expected Future)

```
prodigy1/
├── README.md
├── .github/
│   ├── copilot-instructions.md
│   └── workflows/
│       └── deploy.yml
├── frontend/
│   ├── package.json
│   ├── src/
│   └── public/
├── backend/
│   ├── *.csproj
│   ├── Functions/
│   └── host.json
└── azure/
    ├── arm-templates/
    └── bicep/
```

Remember: **ALWAYS validate builds and deployments with appropriate timeouts, and test functionality manually after any changes.**