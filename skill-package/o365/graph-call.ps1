# graph-call.ps1 - Execute Microsoft Graph API calls
# Usage: .\graph-call.ps1 METHOD ENDPOINT [BODY] [API_VERSION]
#
# Examples:
#   .\graph-call.ps1 GET /users
#   .\graph-call.ps1 GET /users/user@domain.com
#   .\graph-call.ps1 POST /teams '{"displayName":"My Team"}'
#   .\graph-call.ps1 GET /sites beta

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
    [string]$Method,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$Endpoint,

    [Parameter(Position=2)]
    [string]$Body,

    [Parameter(Position=3)]
    [ValidateSet("v1.0", "beta")]
    [string]$ApiVersion = "v1.0"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get token
$Token = & "$ScriptDir\get-token.ps1" graph

if (-not $Token) {
    Write-Error "Failed to acquire token"
    exit 1
}

# Build URL
if ($Endpoint.StartsWith("/")) {
    $Url = "https://graph.microsoft.com/$ApiVersion$Endpoint"
} else {
    $Url = "https://graph.microsoft.com/$ApiVersion/$Endpoint"
}

# Build headers
$Headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type"  = "application/json"
}

# Execute request
$Params = @{
    Uri     = $Url
    Method  = $Method
    Headers = $Headers
}

if ($Body -and ($Method -in @("POST", "PATCH", "PUT"))) {
    $Params.Body = $Body
}

try {
    $Response = Invoke-RestMethod @Params
    $Response | ConvertTo-Json -Depth 10
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    $ErrorBody = $_.ErrorDetails.Message
    Write-Error "Graph API error $StatusCode : $ErrorBody"
    exit 1
}
