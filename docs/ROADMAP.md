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

## Phase 2: Azure AD Setup (Complete)
- [x] App Registration created
- [x] Client secret generated
- [x] API permissions configured
- [x] Admin consent granted
- [x] Credentials verified - authentication successful

## Phase 3: Configure MCP in Claude Code (Next)
Run from the project directory:
```bash
claude mcp add o365-admin node dist/index.js \
  -e AZURE_CLIENT_ID=<your-client-id> \
  -e AZURE_CLIENT_SECRET=<your-client-secret> \
  -e AZURE_TENANT_ID=<your-tenant-id>
```

Or add to `~/.claude/settings.json` manually.

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
