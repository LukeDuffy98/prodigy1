import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('HTTP trigger function processed a request for getData.');

    try {
        // Simulate some data processing
        const data = {
            message: "Hello from Azure Functions!",
            timestamp: new Date().toISOString(),
            environment: process.env.AZURE_FUNCTIONS_ENVIRONMENT || 'local',
            requestId: context.invocationId
        };

        context.res = {
            status: 200,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type, Authorization"
            },
            body: data
        };
    } catch (error) {
        context.log.error('Error in getData function:', error);
        
        context.res = {
            status: 500,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: {
                error: "Internal server error",
                message: "An error occurred while processing your request"
            }
        };
    }
};

export default httpTrigger;
