# get-token.ps1 - Acquire and cache Azure AD tokens for Microsoft Graph/Power Platform
# Usage: .\get-token.ps1 [graph|powerplatform]

param(
    [string]$ScopeType = "graph"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EnvFile = Join-Path $ScriptDir ".env"
$CacheDir = Join-Path $ScriptDir ".cache"

# Load credentials from .env file
if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}

$ClientId = $env:AZURE_CLIENT_ID
$ClientSecret = $env:AZURE_CLIENT_SECRET
$TenantId = $env:AZURE_TENANT_ID

if (-not $ClientId -or -not $ClientSecret -or -not $TenantId) {
    Write-Error "Missing credentials. Set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID in $EnvFile"
    exit 1
}

# Determine scope based on argument
switch ($ScopeType) {
    "graph" {
        $Scope = "https://graph.microsoft.com/.default"
        $CacheFile = Join-Path $CacheDir "graph_token.json"
    }
    "powerplatform" {
        $Scope = "https://service.powerapps.com/.default"
        $CacheFile = Join-Path $CacheDir "powerplatform_token.json"
    }
    default {
        Write-Error "Unknown scope type '$ScopeType'. Use 'graph' or 'powerplatform'"
        exit 1
    }
}

# Create cache directory
if (-not (Test-Path $CacheDir)) {
    New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
}

# Check for cached token
if (Test-Path $CacheFile) {
    $CachedData = Get-Content $CacheFile | ConvertFrom-Json
    $CurrentTime = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()

    # Use cached token if not expired (with 5 min buffer)
    if ($CachedData.expiresAt -and $CurrentTime -lt ($CachedData.expiresAt - 300)) {
        Write-Output $CachedData.token
        exit 0
    }
}

# Request new token
$TokenEndpoint = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

$Body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    scope         = $Scope
    grant_type    = "client_credentials"
}

try {
    $Response = Invoke-RestMethod -Uri $TokenEndpoint -Method Post -Body $Body -ContentType "application/x-www-form-urlencoded"
} catch {
    Write-Error "Error acquiring token: $_"
    exit 1
}

$AccessToken = $Response.access_token
$ExpiresIn = $Response.expires_in

if (-not $AccessToken) {
    Write-Error "Failed to parse access token from response"
    exit 1
}

# Cache the token
$ExpiryTime = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds() + $ExpiresIn
$CacheData = @{
    token = $AccessToken
    expiresAt = $ExpiryTime
} | ConvertTo-Json

$CacheData | Set-Content $CacheFile -Force

Write-Output $AccessToken
