# Power Platform API - Core Patterns

This skill provides the foundational knowledge for making Power Platform API calls.

## Authentication

### Token Acquisition
**TODO:** Document Power Platform API authentication in detail.

Power Platform uses Azure AD for authentication, similar to Graph API but with different scopes.

#### Common Scopes
- Flow Management: `https://service.flow.microsoft.com/.default`
- PowerApps: `https://service.powerapps.com/.default`
- Dataverse: `https://{environment}.crm.dynamics.com/.default`

### Relationship to Dataverse
**TODO:** Document how Power Platform APIs relate to Dataverse and when to use each.

Power Platform environments are built on Dataverse (formerly Common Data Service). Some operations require Dataverse API calls rather than Power Platform management APIs.

## Environments

### Environment Discovery
**TODO:** Document how to list and identify Power Platform environments.

Base URL pattern: `https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments`

#### Environment Types
- Default environment (created automatically per tenant)
- Production environments
- Sandbox environments
- Developer environments

### Environment IDs and URLs
**TODO:** Document environment ID formats and regional URLs.

Environment IDs are GUIDs that identify each Power Platform environment. Regional URLs follow patterns like:
- `https://{region}.api.flow.microsoft.com/`

## Request Patterns

### Base URLs
**TODO:** Document base URLs for different Power Platform services.

- Flow Management API: `https://api.flow.microsoft.com/`
- PowerApps API: `https://api.powerapps.com/`
- BAP API (Business Application Platform): `https://api.bap.microsoft.com/`

### Common Operations Structure
**TODO:** Document standard request/response patterns.

Most Power Platform APIs follow REST conventions:
```
GET /providers/Microsoft.ProcessSimple/environments/{environment-id}/flows
```

### API Versions
**TODO:** Document API versioning approach.

Power Platform APIs use query string versioning:
```
?api-version=2016-11-01
```

## Error Handling

### Power Platform Specific Errors
**TODO:** Document common error codes and their meanings.

Expected error patterns:
- 400: Bad request / validation errors
- 401: Unauthorized (token issues)
- 403: Forbidden (insufficient permissions or licensing)
- 404: Resource not found
- 429: Throttled

### Licensing Errors
**TODO:** Document licensing-related errors and solutions.

Some Power Platform operations require specific licenses (Power Automate Premium, per-user, per-flow).

## Throttling

### Rate Limits
**TODO:** Document Power Platform specific rate limits.

Power Platform has its own throttling limits separate from Microsoft Graph.

### Best Practices
**TODO:** Document recommended approaches for high-volume operations.

- Implement retry logic with exponential backoff
- Batch operations where possible
- Cache environment information
