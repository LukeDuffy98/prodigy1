import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('Health check requested.');

    const healthData = {
        status: "healthy",
        timestamp: new Date().toISOString(),
        version: "1.0.0",
        environment: process.env.AZURE_FUNCTIONS_ENVIRONMENT || 'local',
        uptime: process.uptime(),
        checks: {
            database: "healthy", // In real app, check actual database connection
            storage: "healthy",  // In real app, check storage connectivity
            apis: "healthy"      // In real app, check external API dependencies
        }
    };

    context.res = {
        status: 200,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        body: healthData
    };
};

export default httpTrigger;
