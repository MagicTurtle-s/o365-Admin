#!/bin/bash
# powerplatform-call.sh - Execute Power Platform API calls
# Usage: ./powerplatform-call.sh METHOD FULL_URL [BODY]
#
# Examples:
#   ./powerplatform-call.sh GET "https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments?api-version=2023-06-01"
#   ./powerplatform-call.sh GET "https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
METHOD="${1:-GET}"
URL="$2"
BODY="$3"

if [[ -z "$URL" ]]; then
    echo "Usage: $0 METHOD FULL_URL [BODY]" >&2
    echo "" >&2
    echo "  METHOD    HTTP method: GET, POST, PATCH, PUT, DELETE" >&2
    echo "  FULL_URL  Complete API URL (Power Platform requires full URLs)" >&2
    echo "  BODY      JSON body for POST/PATCH/PUT requests" >&2
    echo "" >&2
    echo "Common base URLs:" >&2
    echo "  - https://api.bap.microsoft.com (Business App Platform)" >&2
    echo "  - https://api.flow.microsoft.com (Power Automate)" >&2
    echo "  - https://api.powerapps.com (Power Apps)" >&2
    exit 1
fi

# Get token
TOKEN=$("$SCRIPT_DIR/get-token.sh" powerplatform)

# Build curl command
CURL_ARGS=(
    -s
    -X "$METHOD"
    -H "Authorization: Bearer $TOKEN"
    -H "Content-Type: application/json"
)

# Add body for write operations
if [[ -n "$BODY" && ("$METHOD" == "POST" || "$METHOD" == "PATCH" || "$METHOD" == "PUT") ]]; then
    CURL_ARGS+=(-d "$BODY")
fi

# Execute request
RESPONSE=$(curl "${CURL_ARGS[@]}" "$URL")

# Pretty print JSON if jq is available
if command -v jq &> /dev/null && echo "$RESPONSE" | jq . &> /dev/null; then
    echo "$RESPONSE" | jq .
else
    echo "$RESPONSE"
fi
