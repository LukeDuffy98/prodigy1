import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('HTTP trigger function processed a request for createData.');

    try {
        // Validate request body
        if (!req.body) {
            context.res = {
                status: 400,
                headers: {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*"
                },
                body: {
                    error: "Bad Request",
                    message: "Request body is required"
                }
            };
            return;
        }

        // Process the data (in a real app, you'd save to database)
        const inputData = req.body;
        const createdData = {
            id: Math.random().toString(36).substr(2, 9),
            ...inputData,
            createdAt: new Date().toISOString(),
            status: 'created'
        };

        context.log('Created data:', createdData);

        context.res = {
            status: 201,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type, Authorization"
            },
            body: createdData
        };
    } catch (error) {
        context.log.error('Error in createData function:', error);
        
        context.res = {
            status: 500,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: {
                error: "Internal server error",
                message: "An error occurred while creating data"
            }
        };
    }
};

export default httpTrigger;
