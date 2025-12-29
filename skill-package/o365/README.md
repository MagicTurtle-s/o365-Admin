# O365 Admin Skill

This skill enables Microsoft 365 administration via Microsoft Graph API and Power Platform APIs.

## Quick Reference

### Scripts

| Script | Purpose |
|--------|---------|
| `graph-call.sh METHOD ENDPOINT [BODY] [VERSION]` | Execute Graph API calls |
| `powerplatform-call.sh METHOD URL [BODY]` | Execute Power Platform API calls |
| `get-token.sh [graph\|powerplatform]` | Get/refresh OAuth tokens |

### Script Location
```
~/.claude/skills/o365/
```

## Graph API Usage

```bash
# Syntax
~/.claude/skills/o365/graph-call.sh METHOD ENDPOINT [BODY] [API_VERSION]
```

### Users

```bash
# List all users
~/.claude/skills/o365/graph-call.sh GET /users

# List users with specific fields
~/.claude/skills/o365/graph-call.sh GET '/users?$select=displayName,mail,department'

# Get specific user
~/.claude/skills/o365/graph-call.sh GET /users/user@domain.com

# Filter users by department
~/.claude/skills/o365/graph-call.sh GET '/users?$filter=department eq '\''Sales'\'''

# Create user
~/.claude/skills/o365/graph-call.sh POST /users '{
  "accountEnabled": true,
  "displayName": "John Doe",
  "mailNickname": "johnd",
  "userPrincipalName": "johnd@contoso.com",
  "passwordProfile": {
    "forceChangePasswordNextSignIn": true,
    "password": "TempPassword123!"
  }
}'

# Update user
~/.claude/skills/o365/graph-call.sh PATCH /users/user-id '{"department": "Engineering"}'

# Delete user
~/.claude/skills/o365/graph-call.sh DELETE /users/user-id
```

### Groups

```bash
# List all groups
~/.claude/skills/o365/graph-call.sh GET /groups

# List Microsoft 365 groups only
~/.claude/skills/o365/graph-call.sh GET '/groups?$filter=groupTypes/any(c:c eq '\''Unified'\'')'

# Get group details
~/.claude/skills/o365/graph-call.sh GET /groups/group-id

# Create Microsoft 365 group
~/.claude/skills/o365/graph-call.sh POST /groups '{
  "displayName": "Marketing Team",
  "mailEnabled": true,
  "mailNickname": "marketing",
  "securityEnabled": false,
  "groupTypes": ["Unified"]
}'

# Create security group
~/.claude/skills/o365/graph-call.sh POST /groups '{
  "displayName": "Finance Admins",
  "mailEnabled": false,
  "mailNickname": "financeadmins",
  "securityEnabled": true
}'

# List group members
~/.claude/skills/o365/graph-call.sh GET /groups/group-id/members

# Add member to group
~/.claude/skills/o365/graph-call.sh POST /groups/group-id/members/'$ref' '{
  "@odata.id": "https://graph.microsoft.com/v1.0/users/user-id"
}'

# Remove member from group
~/.claude/skills/o365/graph-call.sh DELETE /groups/group-id/members/user-id/'$ref'
```

### Teams

```bash
# List all teams
~/.claude/skills/o365/graph-call.sh GET '/groups?$filter=resourceProvisioningOptions/Any(x:x eq '\''Team'\'')'

# Create team from scratch
~/.claude/skills/o365/graph-call.sh POST /teams '{
  "displayName": "Project Alpha",
  "description": "Project Alpha team",
  "template@odata.bind": "https://graph.microsoft.com/v1.0/teamsTemplates('\''standard'\'')"
}'

# Create team from existing group
~/.claude/skills/o365/graph-call.sh PUT /groups/group-id/team '{
  "memberSettings": {"allowCreateUpdateChannels": true},
  "messagingSettings": {"allowUserEditMessages": true},
  "funSettings": {"allowGiphy": true}
}'

# List channels
~/.claude/skills/o365/graph-call.sh GET /teams/team-id/channels

# Create channel
~/.claude/skills/o365/graph-call.sh POST /teams/team-id/channels '{
  "displayName": "General Discussion",
  "description": "Channel for general topics"
}'

# List team members
~/.claude/skills/o365/graph-call.sh GET /teams/team-id/members

# Add team member
~/.claude/skills/o365/graph-call.sh POST /teams/team-id/members '{
  "@odata.type": "#microsoft.graph.aadUserConversationMember",
  "roles": ["member"],
  "user@odata.bind": "https://graph.microsoft.com/v1.0/users/user-id"
}'
```

### SharePoint Sites

```bash
# List all sites
~/.claude/skills/o365/graph-call.sh GET /sites

# Search sites
~/.claude/skills/o365/graph-call.sh GET '/sites?search=project'

# Get site by path
~/.claude/skills/o365/graph-call.sh GET /sites/contoso.sharepoint.com:/sites/marketing

# List document libraries
~/.claude/skills/o365/graph-call.sh GET /sites/site-id/drives

# List items in a library
~/.claude/skills/o365/graph-call.sh GET /sites/site-id/drives/drive-id/root/children

# Get site lists
~/.claude/skills/o365/graph-call.sh GET /sites/site-id/lists

# Create a list
~/.claude/skills/o365/graph-call.sh POST /sites/site-id/lists '{
  "displayName": "Project Tasks",
  "list": {"template": "genericList"}
}'
```

### Mail

```bash
# List user's messages
~/.claude/skills/o365/graph-call.sh GET /users/user-id/messages

# Send mail (as application)
~/.claude/skills/o365/graph-call.sh POST /users/user-id/sendMail '{
  "message": {
    "subject": "Hello",
    "body": {"contentType": "Text", "content": "Hello from Graph API"},
    "toRecipients": [{"emailAddress": {"address": "recipient@example.com"}}]
  }
}'

# List calendar events
~/.claude/skills/o365/graph-call.sh GET /users/user-id/calendar/events

# Create calendar event
~/.claude/skills/o365/graph-call.sh POST /users/user-id/calendar/events '{
  "subject": "Team Meeting",
  "start": {"dateTime": "2024-01-15T10:00:00", "timeZone": "UTC"},
  "end": {"dateTime": "2024-01-15T11:00:00", "timeZone": "UTC"}
}'
```

### Using Beta API

Append `beta` as the 4th argument:
```bash
~/.claude/skills/o365/graph-call.sh GET /users beta
```

## Power Platform API Usage

```bash
# Syntax (requires full URL)
~/.claude/skills/o365/powerplatform-call.sh METHOD FULL_URL [BODY]
```

### Environments

```bash
# List environments
~/.claude/skills/o365/powerplatform-call.sh GET \
  "https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments?api-version=2023-06-01"

# Get specific environment
~/.claude/skills/o365/powerplatform-call.sh GET \
  "https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments/env-id?api-version=2023-06-01"
```

### Power Automate Flows

```bash
# List flows in environment
~/.claude/skills/o365/powerplatform-call.sh GET \
  "https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/scopes/admin/environments/env-id/v2/flows?api-version=2016-11-01"
```

## Query Parameters

### Common Patterns

| Parameter | Example | Description |
|-----------|---------|-------------|
| `$select` | `$select=displayName,mail` | Return only specified fields |
| `$filter` | `$filter=department eq 'Sales'` | Filter results |
| `$top` | `$top=10` | Limit results |
| `$orderby` | `$orderby=displayName` | Sort results |
| `$expand` | `$expand=manager` | Include related entities |
| `$count` | `$count=true` | Include total count |

### Filter Operators

| Operator | Example |
|----------|---------|
| eq | `$filter=department eq 'Sales'` |
| ne | `$filter=department ne 'Sales'` |
| startswith | `$filter=startswith(displayName,'John')` |
| endswith | `$filter=endswith(mail,'@contoso.com')` |
| contains | `$filter=contains(displayName,'admin')` |
| and/or | `$filter=department eq 'Sales' and city eq 'Seattle'` |

## Error Handling

| Status | Meaning | Action |
|--------|---------|--------|
| 200 | Success | Process response |
| 201 | Created | Resource created |
| 204 | No Content | Success (no body) |
| 400 | Bad Request | Check request format |
| 401 | Unauthorized | Token expired/invalid |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 429 | Throttled | Wait and retry |

## Setup

1. Copy skill folder to `~/.claude/skills/o365/`
2. Copy `.env.example` to `.env` and add credentials:
   ```
   AZURE_CLIENT_ID=your-client-id
   AZURE_CLIENT_SECRET=your-client-secret
   AZURE_TENANT_ID=your-tenant-id
   ```
3. Make scripts executable: `chmod +x ~/.claude/skills/o365/*.sh`
4. Add the `/o365` slash command to load this skill

## Required Permissions

Ensure your Azure AD app has these API permissions (Application type):

| Service | Permissions |
|---------|-------------|
| Users/Groups | User.ReadWrite.All, Group.ReadWrite.All, Directory.ReadWrite.All |
| Teams | Team.Create, TeamSettings.ReadWrite.All, Channel.Create |
| SharePoint | Sites.ReadWrite.All, Sites.Manage.All |
| Mail | Mail.ReadWrite, Mail.Send, Calendars.ReadWrite |
| Power Platform | (Uses separate token scope) |
