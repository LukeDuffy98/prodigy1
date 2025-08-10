# API Documentation

This document describes the REST API endpoints provided by the Azure Functions backend.

## Base URL

- **Local Development**: `http://localhost:7071/api`
- **Development**: `https://prodigy1-dev-funcapp.azurewebsites.net/api`
- **Production**: `https://prodigy1-prod-funcapp.azurewebsites.net/api`

## Authentication

Currently, the API uses function-level authentication. Include the function key in requests:

```
?code=YOUR_FUNCTION_KEY
```

## Endpoints

### Health Check

Check the health status of the API.

**GET** `/health`

#### Response
```json
{
  "status": "healthy",
  "timestamp": "2025-08-10T10:12:05.123Z",
  "version": "1.0.0",
  "environment": "dev",
  "uptime": 3600,
  "checks": {
    "database": "healthy",
    "storage": "healthy",
    "apis": "healthy"
  }
}
```

### Get Data

Retrieve data from the backend.

**GET** `/getData`

#### Response
```json
{
  "message": "Hello from Azure Functions!",
  "timestamp": "2025-08-10T10:12:05.123Z",
  "environment": "dev",
  "requestId": "12345678-1234-1234-1234-123456789012"
}
```

### Create Data

Create new data in the system.

**POST** `/createData`

#### Request Body
```json
{
  "name": "Sample Data",
  "description": "This is sample data",
  "category": "example"
}
```

#### Response
```json
{
  "id": "abc123def",
  "name": "Sample Data",
  "description": "This is sample data",
  "category": "example",
  "createdAt": "2025-08-10T10:12:05.123Z",
  "status": "created"
}
```

## Error Handling

All endpoints return consistent error responses:

### 400 Bad Request
```json
{
  "error": "Bad Request",
  "message": "Request body is required"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error",
  "message": "An error occurred while processing your request"
}
```

## CORS

The API supports CORS for the following origins:
- `http://localhost:3000` (development)
- Your production frontend domain

## Rate Limiting

Currently, no rate limiting is implemented. Consider implementing Azure API Management for production workloads.

## Examples

### JavaScript/TypeScript (Frontend)

```javascript
// GET request
const response = await fetch(`${API_BASE_URL}/getData`);
const data = await response.json();

// POST request
const response = await fetch(`${API_BASE_URL}/createData`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: 'New Item',
    description: 'Item description'
  })
});
const result = await response.json();
```

### cURL

```bash
# GET request
curl -X GET "https://prodigy1-dev-funcapp.azurewebsites.net/api/getData?code=YOUR_FUNCTION_KEY"

# POST request
curl -X POST "https://prodigy1-dev-funcapp.azurewebsites.net/api/createData?code=YOUR_FUNCTION_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","description":"Test data"}'
```
