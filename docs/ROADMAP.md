# o365-Admin MCP Roadmap

## Current Status
- [x] MCP server with 4 base tools implemented
- [x] Graph API skill fully documented
- [x] SharePoint sites resource fully documented
- [x] Dependencies installed and TypeScript compiles
- [x] Server starts successfully

## Phase 1: Build & Test (Complete)
- [x] `npm install` - Dependencies installed
- [x] `npm run build` - TypeScript compiles without errors
- [x] `npm run dev` - Server starts successfully
- [x] `dist/index.js` exists

## Phase 2: Azure AD Setup (Required for API calls)
User must complete in Azure Portal:
1. Create App Registration named `o365-Admin-MCP`
2. Create client secret (save immediately - only shown once)
3. Add API permissions:
   - **SharePoint**: Sites.ReadWrite.All, Sites.Manage.All
   - **Teams**: Team.Create, TeamSettings.ReadWrite.All, Channel.Create, ChannelSettings.ReadWrite.All
   - **Users**: Directory.Read.All, Directory.ReadWrite.All, User.ReadWrite.All, Group.ReadWrite.All
   - **Mail**: Mail.ReadWrite, Mail.Send, Calendars.ReadWrite
4. Grant admin consent
5. Note Client ID, Tenant ID, and Secret

## Phase 3: Configure MCP in Claude Code
```bash
claude mcp add o365-admin node dist/index.js
```

Or add to settings manually with environment variables for credentials.

## Phase 4: Complete Resource Documentation (Optional)
Fill in TODO sections in scaffolded resource files:

| File | TODOs | Priority |
|------|-------|----------|
| `resources/graph/teams.md` | 20 | Medium |
| `resources/graph/users.md` | 25 | Medium |
| `resources/graph/mail.md` | 23 | Medium |
| `resources/powerplatform/flows.md` | 20 | Low |
| `resources/powerplatform/environments.md` | 19 | Low |
| `skills/powerplatform-api.md` | 11 | Low |

## Architecture
The MCP exposes only 4 base tools. Claude reads skill/resource documentation to learn API patterns, then executes calls via generic executors:

- `list_skills` - Returns available skills and resources
- `read_skill` - Loads documentation into context
- `graph_api_call` - Execute Microsoft Graph API calls
- `powerplatform_api_call` - Execute Power Platform API calls
