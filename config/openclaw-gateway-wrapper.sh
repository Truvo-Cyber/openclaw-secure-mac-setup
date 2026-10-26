#!/bin/bash
# OpenClaw 2026.10.7 drops GOOGLE_APPLICATION_CREDENTIALS from the config file's env section,
# so the gateway service gets the Vertex AI settings from its process environment instead.
# Install the service with: openclaw gateway install --wrapper <path-to-this-file>   (chmod 700)
set -euo pipefail
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.openclaw-secrets/openclaw-sa.json"   # chmod 600, only copy
export GOOGLE_CLOUD_PROJECT="<your-project-id>"
export GOOGLE_CLOUD_LOCATION="global"
export PATH="$HOME/.npm-global/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
exec "$HOME/.npm-global/bin/openclaw" "$@"
