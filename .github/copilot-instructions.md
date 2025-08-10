# GitHub Copilot Instructions for Prodigy1

## Project Overview
This is a modern web application with an Azure App Service frontend and Azure Function backend. The project emphasizes clean, maintainable code and follows best practices for cloud-native development.

## Code Style Guidelines
- Use TypeScript for frontend development
- Follow Azure Functions best practices for backend
- Implement proper error handling and logging
- Use async/await for asynchronous operations
- Follow REST API conventions
- Implement proper input validation and sanitization

## Architecture Patterns
- Prefer dependency injection where applicable
- Use environment variables for configuration
- Implement proper separation of concerns
- Follow SOLID principles
- Use appropriate design patterns (Repository, Factory, etc.)

## Testing Requirements
- Write unit tests for all business logic
- Include integration tests for API endpoints
- Mock external dependencies in tests
- Aim for high test coverage
- Use descriptive test names and arrange-act-assert pattern

## Security Considerations
- Never hardcode secrets or API keys
- Validate all inputs
- Use HTTPS for all external communications
- Implement proper authentication and authorization
- Follow OWASP security guidelines

## Azure-Specific Guidelines
- Use Azure Key Vault for secrets management
- Implement proper Application Insights telemetry
- Follow Azure naming conventions
- Use managed identities where possible
- Optimize for Azure Function cold starts

## Code Review Focus Areas
When suggesting code improvements, prioritize:
1. Security vulnerabilities
2. Performance optimizations
3. Code maintainability
4. Error handling
5. Documentation completeness
6. Test coverage

## Preferred Libraries and Frameworks
- Frontend: React, TypeScript, Axios for HTTP requests
- Backend: Azure Functions runtime v4, TypeScript
- Testing: Jest, Testing Library
- Linting: ESLint with TypeScript support
- Formatting: Prettier

## Documentation Standards
- Include JSDoc comments for all public functions
- Maintain up-to-date README files
- Document API endpoints with clear examples
- Include troubleshooting guides for common issues