# o365-Admin Roadmap

## Current Status
- [x] Azure AD App Registration configured
- [x] Authentication verified working
- [x] Two deployment options available: MCP Server or Skill+Scripts

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

## Phase 3: Choose Deployment Option

### Option A: Skill + Scripts (Recommended)
Portable, on-demand O365 admin via `/o365` slash command. No MCP configuration needed.

**Install:**
```bash
cd skill-package && ./install.sh
```

**Configure credentials:**
```bash
cp ~/.claude/skills/o365/.env.example ~/.claude/skills/o365/.env
# Edit .env with your Azure AD credentials
```

**Use in Claude Code:**
```
/o365
> List all users in the tenant
```

**Pros:**
- Works from any project via `/o365` command
- No MCP configuration needed
- Portable - just copy the skill folder
- On-demand - only loaded when you invoke it

### Option B: MCP Server
Traditional MCP integration with dedicated tools.

```bash
claude mcp add o365-admin node dist/index.js \
  -e AZURE_CLIENT_ID=<your-client-id> \
  -e AZURE_CLIENT_SECRET=<your-client-secret> \
  -e AZURE_TENANT_ID=<your-tenant-id>
```

**Pros:**
- Native tool integration
- Structured responses
- Better for dedicated O365 admin sessions

## Architecture Comparison

| Aspect | Skill + Scripts | MCP Server |
|--------|-----------------|------------|
| Activation | `/o365` slash command | Auto-loads at session start |
| Scope | Global (works anywhere) | Project or global |
| Tools | Bash scripts | Native MCP tools |
| Configuration | Copy files + .env | `claude mcp add` |
| Portability | High | Medium |

## File Structure

```
o365-Admin/
├── src/                      # MCP server source
│   └── index.ts
├── dist/                     # Compiled MCP server
│   └── index.js
├── skill-package/            # Skill + Scripts deployment
│   ├── install.sh            # Installer script
│   ├── o365/
│   │   ├── README.md         # Skill documentation
│   │   ├── get-token.sh      # Token management
│   │   ├── graph-call.sh     # Graph API executor
│   │   ├── powerplatform-call.sh
│   │   └── .env.example
│   └── commands/
│       └── o365.md           # Slash command
├── skills/                   # API pattern documentation
└── resources/                # Endpoint-specific docs
```
