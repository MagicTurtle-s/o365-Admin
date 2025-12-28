# Microsoft Graph API - Core Patterns

This skill provides the foundational knowledge for making Microsoft Graph API calls.

## Authentication

### Client Credentials Flow (App-Only)
Used for application-to-application scenarios without a signed-in user.

```
POST https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

client_id={client-id}
&scope=https://graph.microsoft.com/.default
&client_secret={client-secret}
&grant_type=client_credentials
```

### Token Usage
Include the access token in all API requests:
```
Authorization: Bearer {access-token}
```

### Delegated vs Application Permissions
- **Application permissions**: Used for app-only access (no user context). Set in Azure AD app registration under "API permissions" as "Application".
- **Delegated permissions**: Used when acting on behalf of a signed-in user. Requires user consent flow.

**When to use each:**
- Use Application permissions for background services, daemons, scheduled tasks
- Use Delegated permissions when the app acts on behalf of a user

## Request Patterns

### Base URLs
- Production: `https://graph.microsoft.com/v1.0`
- Beta (preview features): `https://graph.microsoft.com/beta`

### HTTP Methods

**GET** - Retrieve resources
```
GET /users
GET /users/{user-id}
GET /sites/{site-id}/lists
```

**POST** - Create resources
```
POST /users
Content-Type: application/json

{
  "displayName": "John Doe",
  "mailNickname": "johnd",
  "userPrincipalName": "johnd@contoso.com",
  ...
}
```

**PATCH** - Update resources (partial update)
```
PATCH /users/{user-id}
Content-Type: application/json

{
  "displayName": "John Smith"
}
```

**PUT** - Replace resources (full replacement)
```
PUT /drives/{drive-id}/root:/{path}/{filename}:/content
Content-Type: application/octet-stream

[file contents]
```

**DELETE** - Remove resources
```
DELETE /users/{user-id}
```

## Common Query Parameters

### $select - Limit returned properties
```
GET /users?$select=displayName,mail,id
```
Reduces payload size and improves performance.

### $filter - Filter results
```
GET /users?$filter=startswith(displayName,'John')
GET /users?$filter=department eq 'Sales'
GET /users?$filter=createdDateTime ge 2024-01-01T00:00:00Z
```

Common operators: `eq`, `ne`, `gt`, `ge`, `lt`, `le`, `and`, `or`, `not`, `startswith`, `endswith`, `contains`

### $expand - Include related resources
```
GET /users/{id}?$expand=manager
GET /groups/{id}?$expand=members
```

### $top and $skip - Pagination
```
GET /users?$top=10
GET /users?$top=10&$skip=20
```

### $orderby - Sorting
```
GET /users?$orderby=displayName
GET /users?$orderby=displayName desc
```

### $count - Get total count
```
GET /users?$count=true
ConsistencyLevel: eventual
```

### $search - Full-text search
```
GET /users?$search="displayName:John"
ConsistencyLevel: eventual
```

## Pagination

### Default Behavior
- Most collections return pages of items (typically 100-999 items)
- Maximum `$top` values vary by resource type

### Using @odata.nextLink
When more results exist, the response includes `@odata.nextLink`:

```json
{
  "value": [...],
  "@odata.nextLink": "https://graph.microsoft.com/v1.0/users?$skiptoken=..."
}
```

To get the next page, make a GET request to the `@odata.nextLink` URL.

### Common $top Limits
| Resource | Max $top |
|----------|----------|
| Users | 999 |
| Messages | 1000 |
| Events | 1000 |
| Files/Items | 1000 |

## Batch Requests

Combine multiple operations into a single request to reduce round trips.

### Batch Request Format
```
POST https://graph.microsoft.com/v1.0/$batch
Content-Type: application/json

{
  "requests": [
    {
      "id": "1",
      "method": "GET",
      "url": "/users/user1@contoso.com"
    },
    {
      "id": "2",
      "method": "GET",
      "url": "/users/user2@contoso.com"
    }
  ]
}
```

### Batch Response
```json
{
  "responses": [
    {
      "id": "1",
      "status": 200,
      "body": { ... }
    },
    {
      "id": "2",
      "status": 200,
      "body": { ... }
    }
  ]
}
```

### When to Use Batch
- Multiple independent read operations
- Creating/updating multiple resources
- Maximum 20 requests per batch
- Requests execute in parallel unless `dependsOn` is specified

## Error Handling

### HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process response |
| 201 | Created | Resource created successfully |
| 204 | No Content | Success with no response body |
| 400 | Bad Request | Check request format/parameters |
| 401 | Unauthorized | Token expired or invalid |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Resource already exists or version conflict |
| 429 | Too Many Requests | Throttled - retry after delay |
| 500 | Internal Server Error | Retry with backoff |
| 503 | Service Unavailable | Retry with backoff |

### Error Response Format
```json
{
  "error": {
    "code": "Request_ResourceNotFound",
    "message": "Resource not found.",
    "innerError": {
      "date": "2024-01-01T00:00:00",
      "request-id": "...",
      "client-request-id": "..."
    }
  }
}
```

### Common Error Codes
- `Authorization_RequestDenied` - Missing or insufficient permissions
- `Request_ResourceNotFound` - Resource doesn't exist
- `Request_BadRequest` - Malformed request
- `InvalidAuthenticationToken` - Token expired or invalid

## Throttling Best Practices

### Respect Retry-After Header
When receiving 429 (Too Many Requests), the response includes:
```
Retry-After: 30
```
Wait the specified seconds before retrying.

### Implement Exponential Backoff
```
Initial delay: 1 second
Retry 1: 2 seconds
Retry 2: 4 seconds
Retry 3: 8 seconds
Maximum delay: 60 seconds
```

### Reduce API Call Volume
- Use batch requests for multiple operations
- Use `$select` to reduce payload sizes
- Cache responses when appropriate
- Use delta queries for sync scenarios

### Throttling Limits (Approximate)
- Per-app: 2000 requests per second
- Per-tenant: 10,000 requests per 10 minutes
- Per-mailbox: 10,000 requests per 10 minutes

### Delta Queries
For sync scenarios, use delta queries to get only changed items:
```
GET /users/delta
```

Store the `@odata.deltaLink` and use it for subsequent requests to get only changes.
