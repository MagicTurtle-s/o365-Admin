#!/bin/bash
# get-token.sh - Acquire and cache Azure AD tokens for Microsoft Graph/Power Platform
# Usage: ./get-token.sh [graph|powerplatform]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
CACHE_DIR="$SCRIPT_DIR/.cache"

# Load credentials
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
fi

# Validate required vars
if [[ -z "$AZURE_CLIENT_ID" || -z "$AZURE_CLIENT_SECRET" || -z "$AZURE_TENANT_ID" ]]; then
    echo "Error: Missing credentials. Set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID in $ENV_FILE" >&2
    exit 1
fi

# Determine scope based on argument
SCOPE_TYPE="${1:-graph}"
case "$SCOPE_TYPE" in
    graph)
        SCOPE="https://graph.microsoft.com/.default"
        CACHE_FILE="$CACHE_DIR/graph_token"
        ;;
    powerplatform)
        SCOPE="https://service.powerapps.com/.default"
        CACHE_FILE="$CACHE_DIR/powerplatform_token"
        ;;
    *)
        echo "Error: Unknown scope type '$SCOPE_TYPE'. Use 'graph' or 'powerplatform'" >&2
        exit 1
        ;;
esac

# Create cache directory
mkdir -p "$CACHE_DIR"

# Check for cached token
if [[ -f "$CACHE_FILE" ]]; then
    CACHED_DATA=$(cat "$CACHE_FILE")
    CACHED_TOKEN=$(echo "$CACHED_DATA" | head -1)
    CACHED_EXPIRY=$(echo "$CACHED_DATA" | tail -1)
    CURRENT_TIME=$(date +%s)

    # Use cached token if not expired (with 5 min buffer)
    if [[ -n "$CACHED_EXPIRY" && "$CURRENT_TIME" -lt "$((CACHED_EXPIRY - 300))" ]]; then
        echo "$CACHED_TOKEN"
        exit 0
    fi
fi

# Request new token
TOKEN_ENDPOINT="https://login.microsoftonline.com/$AZURE_TENANT_ID/oauth2/v2.0/token"

RESPONSE=$(curl -s -X POST "$TOKEN_ENDPOINT" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=$AZURE_CLIENT_ID" \
    -d "client_secret=$AZURE_CLIENT_SECRET" \
    -d "scope=$SCOPE" \
    -d "grant_type=client_credentials")

# Check for error
if echo "$RESPONSE" | grep -q '"error"'; then
    echo "Error acquiring token: $RESPONSE" >&2
    exit 1
fi

# Extract token and expiry
ACCESS_TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
EXPIRES_IN=$(echo "$RESPONSE" | grep -o '"expires_in":[0-9]*' | cut -d':' -f2)

if [[ -z "$ACCESS_TOKEN" ]]; then
    echo "Error: Failed to parse access token from response" >&2
    exit 1
fi

# Cache the token
EXPIRY_TIME=$(($(date +%s) + EXPIRES_IN))
echo -e "$ACCESS_TOKEN\n$EXPIRY_TIME" > "$CACHE_FILE"
chmod 600 "$CACHE_FILE"

echo "$ACCESS_TOKEN"
