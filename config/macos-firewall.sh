#!/bin/bash
# Run on the HOST Mac (needs admin). Turns on the Application Firewall, stealth mode,
# and blocks inbound connections to Lume (its VNC server listens on every interface).
# Afterwards also turn off "Automatically allow downloaded signed software" in
# System Settings > Network > Firewall > Options, then test VNC from a SECOND device.
set -euo pipefail
FW=/usr/libexec/ApplicationFirewall/socketfilterfw
LUME="$HOME/.local/share/lume/lume.app"
sudo "$FW" --setglobalstate on
sudo "$FW" --setstealthmode on
sudo "$FW" --add "$LUME"
sudo "$FW" --blockapp "$LUME"
"$FW" --getglobalstate
"$FW" --getappblocked "$LUME"
