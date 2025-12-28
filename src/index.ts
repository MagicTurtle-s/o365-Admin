import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";
import { ClientSecretCredential } from "@azure/identity";
import * as fs from "fs";
import * as path from "path";

const config = {
  clientId: process.env.AZURE_CLIENT_ID || "",
  clientSecret: process.env.AZURE_CLIENT_SECRET || "",
  tenantId: process.env.AZURE_TENANT_ID || "",
};

let graphToken: { token: string; expiresOn: Date } | null = null;
let powerPlatformToken: { token: string; expiresOn: Date } | null = null;

const baseDir = path.dirname(path.dirname(new URL(import.meta.url).pathname));

async function getGraphToken(): Promise<string> {
  if (graphToken && graphToken.expiresOn > new Date()) {
    return graphToken.token;
  }
  if (!config.clientId || !config.clientSecret || !config.tenantId) {
    throw new Error("Missing Azure AD credentials. Set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID environment variables.");
  }
  const credential = new ClientSecretCredential(config.tenantId, config.clientId, config.clientSecret);
  const tokenResponse = await credential.getToken("https://graph.microsoft.com/.default");
  if (!tokenResponse) throw new Error("Failed to acquire Graph API token");
  graphToken = {
    token: tokenResponse.token,
    expiresOn: tokenResponse.expiresOnTimestamp ? new Date(tokenResponse.expiresOnTimestamp) : new Date(Date.now() + 3600000),
  };
  return graphToken.token;
}

async function getPowerPlatformToken(): Promise<string> {
  if (powerPlatformToken && powerPlatformToken.expiresOn > new Date()) {
    return powerPlatformToken.token;
  }
  if (!config.clientId || !config.clientSecret || !config.tenantId) {
    throw new Error("Missing Azure AD credentials. Set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID environment variables.");
  }
  const credential = new ClientSecretCredential(config.tenantId, config.clientId, config.clientSecret);
  const tokenResponse = await credential.getToken("https://service.powerapps.com/.default");
  if (!tokenResponse) throw new Error("Failed to acquire Power Platform token");
  powerPlatformToken = {
    token: tokenResponse.token,
    expiresOn: tokenResponse.expiresOnTimestamp ? new Date(tokenResponse.expiresOnTimestamp) : new Date(Date.now() + 3600000),
  };
  return powerPlatformToken.token;
}

function listSkillsAndResources(): { skills: string[]; resources: Record<string, string[]> } {
  const skillsDir = path.join(baseDir, "skills");
  const resourcesDir = path.join(baseDir, "resources");
  const skills: string[] = [];
  if (fs.existsSync(skillsDir)) {
    const files = fs.readdirSync(skillsDir);
    for (const file of files) {
      if (file.endsWith(".md")) skills.push(file.replace(".md", ""));
    }
  }
  const resources: Record<string, string[]> = {};
  if (fs.existsSync(resourcesDir)) {
    const apis = fs.readdirSync(resourcesDir);
    for (const api of apis) {
      const apiPath = path.join(resourcesDir, api);
      if (fs.statSync(apiPath).isDirectory()) {
        resources[api] = [];
        const resourceFiles = fs.readdirSync(apiPath);
        for (const file of resourceFiles) {
          if (file.endsWith(".md")) resources[api].push(file.replace(".md", ""));
        }
      }
    }
  }
  return { skills, resources };
}

function readSkillOrResource(type: "skill" | "resource", name: string): string {
  let filePath: string;
  if (type === "skill") {
    filePath = path.join(baseDir, "skills", name + ".md");
  } else {
    const parts = name.split("/");
    if (parts.length !== 2) throw new Error("Resource name must be in format api/resource");
    filePath = path.join(baseDir, "resources", parts[0], parts[1] + ".md");
  }
  if (!fs.existsSync(filePath)) throw new Error(type + " not found at " + filePath);
  return fs.readFileSync(filePath, "utf-8");
}

async function graphApiCall(method: string, endpoint: string, body?: unknown, apiVersion: string = "v1.0"): Promise<unknown> {
  const token = await getGraphToken();
  const baseUrl = "https://graph.microsoft.com/" + apiVersion;
  const url = endpoint.startsWith("/") ? baseUrl + endpoint : baseUrl + "/" + endpoint;
  const headers: Record<string, string> = { Authorization: "Bearer " + token, "Content-Type": "application/json" };
  const options: RequestInit = { method: method.toUpperCase(), headers };
  if (body && (method === "POST" || method === "PATCH" || method === "PUT")) {
    options.body = JSON.stringify(body);
  }
  const response = await fetch(url, options);
  if (!response.ok) {
    const errorText = await response.text();
    let errorDetails: unknown;
    try { errorDetails = JSON.parse(errorText); } catch { errorDetails = errorText; }
    throw new Error("Graph API error " + response.status + ": " + JSON.stringify(errorDetails));
  }
  if (response.status === 204) return { success: true, status: 204 };
  const contentType = response.headers.get("content-type");
  if (contentType && contentType.includes("application/json")) return await response.json();
  return { success: true, status: response.status };
}

async function powerPlatformApiCall(method: string, endpoint: string, body?: unknown, environmentId?: string): Promise<unknown> {
  const token = await getPowerPlatformToken();
  const headers: Record<string, string> = { Authorization: "Bearer " + token, "Content-Type": "application/json" };
  const options: RequestInit = { method: method.toUpperCase(), headers };
  if (body && (method === "POST" || method === "PATCH" || method === "PUT")) {
    options.body = JSON.stringify(body);
  }
  const response = await fetch(endpoint, options);
  if (!response.ok) {
    const errorText = await response.text();
    let errorDetails: unknown;
    try { errorDetails = JSON.parse(errorText); } catch { errorDetails = errorText; }
    throw new Error("Power Platform API error " + response.status + ": " + JSON.stringify(errorDetails));
  }
  if (response.status === 204) return { success: true, status: 204 };
  const contentType = response.headers.get("content-type");
  if (contentType && contentType.includes("application/json")) return await response.json();
  return { success: true, status: response.status };
}

const tools: Tool[] = [
  {
    name: "list_skills",
    description: "Returns available skills and resource references. Skills contain API patterns and best practices. Resources contain endpoint-specific documentation for different Microsoft 365 services.",
    inputSchema: { type: "object", properties: {}, required: [] },
  },
  {
    name: "read_skill",
    description: "Loads a skill or resource reference into context. Use this to learn API patterns before making calls.",
    inputSchema: {
      type: "object",
      properties: {
        type: { type: "string", enum: ["skill", "resource"], description: "Whether to read a skill or resource reference" },
        name: { type: "string", description: "Skill name (e.g., graph-api) or resource path (e.g., graph/sites)" },
      },
      required: ["type", "name"],
    },
  },
  {
    name: "graph_api_call",
    description: "Execute a Microsoft Graph API call. Read the graph-api skill and relevant resource documentation first.",
    inputSchema: {
      type: "object",
      properties: {
        method: { type: "string", enum: ["GET", "POST", "PATCH", "PUT", "DELETE"], description: "HTTP method" },
        endpoint: { type: "string", description: "API endpoint path after the base URL" },
        body: { type: "object", description: "Request body for POST/PATCH/PUT requests" },
        api_version: { type: "string", enum: ["v1.0", "beta"], description: "API version (default: v1.0)" },
      },
      required: ["method", "endpoint"],
    },
  },
  {
    name: "powerplatform_api_call",
    description: "Execute a Power Platform API call. Read the powerplatform-api skill and relevant resource documentation first.",
    inputSchema: {
      type: "object",
      properties: {
        method: { type: "string", enum: ["GET", "POST", "PATCH", "PUT", "DELETE"], description: "HTTP method" },
        endpoint: { type: "string", description: "Full API endpoint URL" },
        body: { type: "object", description: "Request body for POST/PATCH/PUT requests" },
        environment_id: { type: "string", description: "Target Power Platform environment ID" },
      },
      required: ["method", "endpoint"],
    },
  },
];

const server = new Server({ name: "o365-admin-mcp", version: "1.0.0" }, { capabilities: { tools: {} } });

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools }));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  try {
    switch (name) {
      case "list_skills": {
        const result = listSkillsAndResources();
        return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
      }
      case "read_skill": {
        const { type, name: skillName } = args as { type: "skill" | "resource"; name: string };
        const content = readSkillOrResource(type, skillName);
        return { content: [{ type: "text", text: content }] };
      }
      case "graph_api_call": {
        const { method, endpoint, body, api_version } = args as { method: string; endpoint: string; body?: unknown; api_version?: string };
        const result = await graphApiCall(method, endpoint, body, api_version || "v1.0");
        return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
      }
      case "powerplatform_api_call": {
        const { method, endpoint, body, environment_id } = args as { method: string; endpoint: string; body?: unknown; environment_id?: string };
        const result = await powerPlatformApiCall(method, endpoint, body, environment_id);
        return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
      }
      default:
        throw new Error("Unknown tool: " + name);
    }
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : "Unknown error occurred";
    return { content: [{ type: "text", text: "Error: " + errorMessage }], isError: true };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("o365-Admin MCP Server started");
}

main().catch((error) => { console.error("Failed to start server:", error); process.exit(1); });
