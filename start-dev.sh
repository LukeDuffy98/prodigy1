#!/bin/bash

# Prodigy1 Local Development Startup Script
# This script starts both frontend and backend services for local development

echo "🚀 Starting Prodigy1 Local Development Environment..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists node; then
    echo "❌ Node.js is not installed. Please install Node.js v18+ from https://nodejs.org/"
    exit 1
fi

if ! command_exists func; then
    echo "❌ Azure Functions Core Tools not found. Installing..."
    npm install -g azure-functions-core-tools@4 --unsafe-perm true
fi

if ! command_exists npm; then
    echo "❌ npm is not installed. Please install Node.js which includes npm."
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "README.md" ] || [ ! -d "frontend" ] || [ ! -d "backend" ]; then
    echo "❌ Please run this script from the root of the prodigy1 project."
    exit 1
fi

# Install dependencies if node_modules don't exist
echo "📦 Installing dependencies..."

if [ ! -d "frontend/node_modules" ]; then
    echo "Installing frontend dependencies..."
    cd frontend && npm install && cd ..
fi

if [ ! -d "backend/node_modules" ]; then
    echo "Installing backend dependencies..."
    cd backend && npm install && cd ..
fi

# Create environment files if they don't exist
echo "⚙️ Setting up environment configuration..."

if [ ! -f "frontend/.env.local" ]; then
    echo "Creating frontend environment file..."
    cp frontend/.env.local.example frontend/.env.local 2>/dev/null || {
        cat > frontend/.env.local << EOF
NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
NEXT_PUBLIC_ENVIRONMENT=development
NEXT_PUBLIC_APP_NAME=Prodigy1
EOF
    }
fi

if [ ! -f "backend/local.settings.json" ]; then
    echo "Creating backend settings file..."
    cat > backend/local.settings.json << EOF
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
EOF
fi

echo "✅ Environment setup complete!"
echo ""
echo "🎯 Starting services..."
echo "   Frontend will be available at: http://localhost:3000"
echo "   Backend will be available at: http://localhost:7071"
echo "   API Health check: http://localhost:7071/api/health"
echo ""
echo "💡 Use Ctrl+C to stop all services"
echo ""

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Stopping all services..."
    jobs -p | xargs -r kill
    exit 0
}

# Set trap to cleanup on exit
trap cleanup INT TERM

# Start backend in background
echo "🔧 Starting Azure Functions backend..."
cd backend
npm run start &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 3

# Start frontend in background
echo "🌐 Starting Next.js frontend..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "✅ Both services are starting up..."
echo "📖 Check the terminal output above for any errors"
echo "🌐 Open http://localhost:3000 in your browser when ready"
echo ""

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
