# powerplatform-call.ps1 - Execute Power Platform API calls
# Usage: .\powerplatform-call.ps1 METHOD FULL_URL [BODY]
#
# Examples:
#   .\powerplatform-call.ps1 GET "https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments?api-version=2023-06-01"

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
    [string]$Method,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$Url,

    [Parameter(Position=2)]
    [string]$Body
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get token
$Token = & "$ScriptDir\get-token.ps1" powerplatform

if (-not $Token) {
    Write-Error "Failed to acquire token"
    exit 1
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
    Write-Error "Power Platform API error $StatusCode : $ErrorBody"
    exit 1
}
