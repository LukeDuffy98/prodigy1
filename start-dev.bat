@echo off
REM Prodigy1 Local Development Startup Script (Windows Batch)
REM This script starts both frontend and backend services for local development

echo 🚀 Starting Prodigy1 Local Development Environment...

REM Check if we're in the correct directory
if not exist "README.md" (
    echo ❌ Please run this script from the root of the prodigy1 project.
    pause
    exit /b 1
)

if not exist "frontend" (
    echo ❌ Frontend directory not found. Please run from project root.
    pause
    exit /b 1
)

if not exist "backend" (
    echo ❌ Backend directory not found. Please run from project root.
    pause
    exit /b 1
)

REM Check for Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js is not installed. Please install Node.js v18+ from https://nodejs.org/
    pause
    exit /b 1
)

REM Check for Azure Functions Core Tools
func --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Azure Functions Core Tools not found. You may need to install it:
    echo npm install -g azure-functions-core-tools@4 --unsafe-perm true
)

echo 📦 Installing dependencies...

REM Install frontend dependencies
if not exist "frontend\node_modules" (
    echo Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
)

REM Install backend dependencies
if not exist "backend\node_modules" (
    echo Installing backend dependencies...
    cd backend
    call npm install
    cd ..
)

echo ⚙️ Setting up environment configuration...

REM Create frontend environment file
if not exist "frontend\.env.local" (
    echo Creating frontend environment file...
    (
        echo NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
        echo NEXT_PUBLIC_ENVIRONMENT=development
        echo NEXT_PUBLIC_APP_NAME=Prodigy1
    ) > "frontend\.env.local"
)

REM Create backend settings file
if not exist "backend\local.settings.json" (
    echo Creating backend settings file...
    (
        echo {
        echo   "IsEncrypted": false,
        echo   "Values": {
        echo     "AzureWebJobsStorage": "UseDevelopmentStorage=true",
        echo     "FUNCTIONS_WORKER_RUNTIME": "node",
        echo     "WEBSITE_NODE_DEFAULT_VERSION": "~18",
        echo     "AzureWebJobsFeatureFlags": "EnableWorkerIndexing",
        echo     "CORS_ORIGINS": "http://localhost:3000"
        echo   },
        echo   "Host": {
        echo     "LocalHttpPort": 7071,
        echo     "CORS": "http://localhost:3000",
        echo     "CORSCredentials": false
        echo   }
        echo }
    ) > "backend\local.settings.json"
)

echo ✅ Environment setup complete!
echo.
echo 🎯 Starting services...
echo    Frontend will be available at: http://localhost:3000
echo    Backend will be available at: http://localhost:7071
echo    API Health check: http://localhost:7071/api/health
echo.
echo 💡 Press Ctrl+C to stop services when done
echo.

REM Start both services
echo 🔧 Starting Azure Functions backend...
start "Backend" cmd /k "cd backend && npm run start"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

echo 🌐 Starting Next.js frontend...
start "Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ✅ Both services are starting up...
echo 📖 Check the opened terminal windows for any errors
echo 🌐 Open http://localhost:3000 in your browser when ready
echo.
echo Press any key to close this window...
pause >nul
