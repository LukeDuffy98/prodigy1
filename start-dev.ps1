# Prodigy1 Local Development Startup Script (PowerShell)
# This script starts both frontend and backend services for local development

Write-Host "🚀 Starting Prodigy1 Local Development Environment..." -ForegroundColor Green

# Function to check if a command exists
function Test-Command {
    param($Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

if (-not (Test-Command "node")) {
    Write-Host "❌ Node.js is not installed. Please install Node.js v18+ from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

if (-not (Test-Command "func")) {
    Write-Host "❌ Azure Functions Core Tools not found. Installing..." -ForegroundColor Yellow
    npm install -g azure-functions-core-tools@4 --unsafe-perm true
}

if (-not (Test-Command "npm")) {
    Write-Host "❌ npm is not installed. Please install Node.js which includes npm." -ForegroundColor Red
    exit 1
}

# Check if we're in the correct directory
if (-not (Test-Path "README.md") -or -not (Test-Path "frontend") -or -not (Test-Path "backend")) {
    Write-Host "❌ Please run this script from the root of the prodigy1 project." -ForegroundColor Red
    exit 1
}

# Install dependencies if node_modules don't exist
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow

if (-not (Test-Path "frontend/node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    Set-Location frontend
    npm install
    Set-Location ..
}

if (-not (Test-Path "backend/node_modules")) {
    Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
    Set-Location backend
    npm install
    Set-Location ..
}

# Create environment files if they don't exist
Write-Host "⚙️ Setting up environment configuration..." -ForegroundColor Yellow

if (-not (Test-Path "frontend/.env.local")) {
    Write-Host "Creating frontend environment file..." -ForegroundColor Cyan
    if (Test-Path "frontend/.env.local.example") {
        Copy-Item "frontend/.env.local.example" "frontend/.env.local"
    }
    else {
        @"
NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
NEXT_PUBLIC_ENVIRONMENT=development
NEXT_PUBLIC_APP_NAME=Prodigy1
"@ | Out-File -FilePath "frontend/.env.local" -Encoding UTF8
    }
}

if (-not (Test-Path "backend/local.settings.json")) {
    Write-Host "Creating backend settings file..." -ForegroundColor Cyan
    @"
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "WEBSITE_NODE_DEFAULT_VERSION": "~18",
    "AzureWebJobsFeatureFlags": "EnableWorkerIndexing",
    "CORS_ORIGINS": "http://localhost:3000"
  },
  "Host": {
    "LocalHttpPort": 7071,
    "CORS": "http://localhost:3000",
    "CORSCredentials": false
  }
}
"@ | Out-File -FilePath "backend/local.settings.json" -Encoding UTF8
}

Write-Host "✅ Environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Starting services..." -ForegroundColor Yellow
Write-Host "   Frontend will be available at: http://localhost:3000" -ForegroundColor Cyan
Write-Host "   Backend will be available at: http://localhost:7071" -ForegroundColor Cyan
Write-Host "   API Health check: http://localhost:7071/api/health" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Use Ctrl+C to stop all services" -ForegroundColor Yellow
Write-Host ""

try {
    # Start backend in background
    Write-Host "🔧 Starting Azure Functions backend..." -ForegroundColor Cyan
    $backendJob = Start-Job -ScriptBlock {
        Set-Location $using:PWD/backend
        npm run start
    }

    # Wait a moment for backend to start
    Start-Sleep -Seconds 3

    # Start frontend in background
    Write-Host "🌐 Starting Next.js frontend..." -ForegroundColor Cyan
    $frontendJob = Start-Job -ScriptBlock {
        Set-Location $using:PWD/frontend
        npm run dev
    }

    Write-Host ""
    Write-Host "✅ Both services are starting up..." -ForegroundColor Green
    Write-Host "📖 Check the job output for any errors: Get-Job | Receive-Job" -ForegroundColor Yellow
    Write-Host "🌐 Open http://localhost:3000 in your browser when ready" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Press any key to stop all services..." -ForegroundColor Yellow

    # Wait for user input
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
finally {
    # Cleanup
    Write-Host ""
    Write-Host "🛑 Stopping all services..." -ForegroundColor Red
    if ($backendJob) { Stop-Job $backendJob; Remove-Job $backendJob }
    if ($frontendJob) { Stop-Job $frontendJob; Remove-Job $frontendJob }
    Write-Host "✅ All services stopped." -ForegroundColor Green
}
