# o365-Admin MCP

A skill-based Microsoft 365 admin MCP server organized around APIs rather than applications. Capabilities are lazy-loaded from instruction files rather than exposed as a large tool manifest.

## Architecture

This MCP exposes only **4 base tools**:

| Tool | Purpose |
|------|---------|
| `list_skills` | Returns available skills and resource references |
| `read_skill` | Loads a skill or resource reference into context |
| `graph_api_call` | Generic Graph API executor |
| `powerplatform_api_call` | Generic Power Platform API executor |

**No domain-specific tools.** Claude reads skills/resources to learn what API calls to construct, then executes via the generic tools.

### Directory Structure

```
o365-Admin/
├── src/
│   └── index.ts           # MCP server with 4 base tools
├── skills/
│   ├── graph-api.md       # Core: auth, request patterns, pagination, errors
│   └── powerplatform-api.md  # Core: auth, environments, request patterns
├── resources/
│   ├── graph/
│   │   ├── sites.md       # SharePoint: sites, drives, lists, permissions
│   │   ├── teams.md       # Teams: teams, channels, tabs, apps
│   │   ├── users.md       # Entra: users, groups, directory roles
│   │   └── mail.md        # Exchange: messages, folders, rules, calendars
│   └── powerplatform/
│       ├── flows.md       # Flow definitions, runs, connections
│       └── environments.md # Environment management, DLP policies
├── README.md
├── package.json
└── tsconfig.json
```

## Prerequisites

- Node.js 18+ 
- Azure AD App Registration with appropriate permissions
- Access to Microsoft 365 tenant

## Azure AD App Registration

### Step 1: Create App Registration

1. Go to [Azure Portal](https://portal.azure.com) > Azure Active Directory > App registrations
2. Click "New registration"
3. Name: `o365-Admin-MCP`
4. Supported account types: Single tenant (or multi-tenant if needed)
5. Click "Register"

### Step 2: Create Client Secret

1. In your app registration, go to "Certificates & secrets"
2. Click "New client secret"
3. Add description and expiry
4. **Copy the secret value immediately** (shown only once)

### Step 3: Add API Permissions

Go to "API permissions" > "Add a permission" > "Microsoft Graph" > "Application permissions"

Add the following permissions based on your needs:

**SharePoint/OneDrive:**
- `Sites.ReadWrite.All`
- `Sites.Manage.All`

**Teams:**
- `Team.Create`
- `TeamSettings.ReadWrite.All`
- `Channel.Create`
- `ChannelSettings.ReadWrite.All`
- `TeamsApp.ReadWrite.All`

**Users/Directory:**
- `Directory.Read.All`
- `Directory.ReadWrite.All`
- `User.ReadWrite.All`
- `Group.ReadWrite.All`
- `RoleManagement.ReadWrite.Directory`

**Mail/Calendar:**
- `Mail.ReadWrite`
- `Mail.Send`
- `Calendars.ReadWrite`
- `MailboxSettings.ReadWrite`

### Step 4: Grant Admin Consent

Click "Grant admin consent for [Your Tenant]" and confirm.

### Step 5: Note Your IDs

From the app registration "Overview" page, copy:
- **Application (client) ID**
- **Directory (tenant) ID**

## Environment Configuration

Set the following environment variables:

```bash
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
export AZURE_TENANT_ID="your-tenant-id"
```

Or create a `.env` file (remember to add to `.gitignore`):

```
AZURE_CLIENT_ID=your-client-id
AZURE_CLIENT_SECRET=your-client-secret
AZURE_TENANT_ID=your-tenant-id
```

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/o365-Admin.git
cd o365-Admin

# Install dependencies
npm install

# Build TypeScript
npm run build

# Run the server
npm start
```

## Development

```bash
# Run in development mode (no build step)
npm run dev
```

## Usage with Claude

### MCP Configuration

Add to your Claude MCP settings:

```json
{
  "mcpServers": {
    "o365-admin": {
      "command": "node",
      "args": ["path/to/o365-Admin/dist/index.js"],
      "env": {
        "AZURE_CLIENT_ID": "your-client-id",
        "AZURE_CLIENT_SECRET": "your-client-secret",
        "AZURE_TENANT_ID": "your-tenant-id"
      }
    }
  }
}
```

### Example Workflow

1. **List available resources:**
   ```
   Use list_skills to see what's available
   ```

2. **Load relevant documentation:**
   ```
   Use read_skill with type="resource" and name="graph/sites"
   ```

3. **Execute API calls:**
   ```
   Use graph_api_call with method="GET" and endpoint="/sites/root"
   ```

### Example Conversation

```
User: Create a new SharePoint document library called "Project Files" in the IT site

Claude: 
1. [Uses read_skill to load graph/sites resource]
2. [Uses graph_api_call GET /sites/contoso.sharepoint.com:/sites/IT to get site ID]
3. [Uses graph_api_call POST /sites/{site-id}/lists with library config]

Result: Document library "Project Files" created successfully.
```

## Adding New Resources

To extend the MCP with new capabilities:

1. Create a new `.md` file in the appropriate directory:
   - `skills/` for core API patterns
   - `resources/graph/` for Graph API endpoints
   - `resources/powerplatform/` for Power Platform endpoints

2. Follow the existing format:
   - Start with "# Title"
   - Include "## Required Permissions" section
   - Document each endpoint with method, URL, and example body
   - Mark incomplete sections with **TODO:**

3. The new file will automatically appear in `list_skills` output

### Resource Template

```markdown
# Resource Name

Brief description of what this resource covers.

## Required Permissions

| Permission | Type | Description |
|------------|------|-------------|
| Permission.Name | Application | What it allows |

## Operation Name

Description of the operation.

\`\`\`
METHOD /endpoint/path
Content-Type: application/json

{
  "property": "value"
}
\`\`\`
```

## Security Considerations

- Never commit credentials to version control
- Use environment variables or secure secret management
- Apply principle of least privilege when assigning permissions
- Regularly rotate client secrets
- Monitor API usage for anomalies

## License

MIT
