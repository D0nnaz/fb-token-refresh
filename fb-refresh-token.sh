#!/usr/bin/env bash
set -euo pipefail

CLIENT_ID="${CLIENT_ID}"
CLIENT_SECRET="${CLIENT_SECRET}"
FB_SHORT_TOKEN="${FB_SHORT_TOKEN}"

RESPONSE=$(curl -s \
  "https://graph.facebook.com/v23.0/oauth/access_token?\
grant_type=fb_exchange_token&\
client_id=${CLIENT_ID}&\
client_secret=${CLIENT_SECRET}&\
fb_exchange_token=${FB_SHORT_TOKEN}")

NEW_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // empty')
if [[ -z "$NEW_TOKEN" ]]; then
  ERR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // "Unknown error"')
  echo "⚠️ FB-refresh failed: $ERR_MSG" >&2
  exit 1
fi

echo "::add-mask::$NEW_TOKEN"

echo "$NEW_TOKEN"
