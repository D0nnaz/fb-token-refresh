#!/usr/bin/env bash
set -euo pipefail

CLIENT_ID="${CLIENT_ID}"
CLIENT_SECRET="${CLIENT_SECRET}"
FB_SHORT_TOKEN="${FB_SHORT_TOKEN}"
HISTORY_FILE="token_history.log"
OUTPUT_FILE="long_lived_token_current.txt"

RESPONSE=$(
  curl -s "https://graph.facebook.com/v23.0/oauth/access_token?\
grant_type=fb_exchange_token&\
client_id=${CLIENT_ID}&\
client_secret=${CLIENT_SECRET}&\
fb_exchange_token=${FB_SHORT_TOKEN}"
)

NEW_TOKEN=$(echo "$RESPONSE" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')

if [[ -n "$NEW_TOKEN" ]]; then
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $NEW_TOKEN" >> "${HISTORY_FILE}"
  echo "$NEW_TOKEN" > "${OUTPUT_FILE}"
  echo "✅ Token refreshed"
else
  echo "⚠️ Refresh failed: $RESPONSE" >&2
  exit 1
fi
