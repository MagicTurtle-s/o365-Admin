#!/bin/bash
# graph-call.sh - Execute Microsoft Graph API calls
# Usage: ./graph-call.sh METHOD ENDPOINT [BODY] [API_VERSION]
#
# Examples:
#   ./graph-call.sh GET /users
#   ./graph-call.sh GET /users/user@domain.com
#   ./graph-call.sh POST /teams '{"displayName":"My Team","description":"Team description","template@odata.bind":"https://graph.microsoft.com/v1.0/teamsTemplates('\''standard'\'')"}'
#   ./graph-call.sh GET /sites beta

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
METHOD="${1:-GET}"
ENDPOINT="$2"
BODY="$3"
API_VERSION="${4:-v1.0}"

if [[ -z "$ENDPOINT" ]]; then
    echo "Usage: $0 METHOD ENDPOINT [BODY] [API_VERSION]" >&2
    echo "" >&2
    echo "  METHOD       HTTP method: GET, POST, PATCH, PUT, DELETE" >&2
    echo "  ENDPOINT     API path (e.g., /users, /teams)" >&2
    echo "  BODY         JSON body for POST/PATCH/PUT requests" >&2
    echo "  API_VERSION  v1.0 (default) or beta" >&2
    exit 1
fi

# Get token
TOKEN=$("$SCRIPT_DIR/get-token.sh" graph)

# Build URL
if [[ "$ENDPOINT" == /* ]]; then
    URL="https://graph.microsoft.com/${API_VERSION}${ENDPOINT}"
else
    URL="https://graph.microsoft.com/${API_VERSION}/${ENDPOINT}"
fi

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
