#!/bin/bash

TARGET_IP="167.234.221.119"
DOMAIN="doable.estonoesterapia.com"
SOUND="/System/Library/Sounds/Basso.aiff"

echo "🔍 Monitoring DNS for $DOMAIN..."
echo "Target IP: $TARGET_IP"
echo "---"

while true; do
  # Resolve domain to IP (get the last line which should be the A record)
  CURRENT_IP=$(dig +short "$DOMAIN" | tail -n1)

  if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo ""
    echo "✓ DNS propagated! $DOMAIN now resolves to $TARGET_IP"
    echo "🔔 Playing sound alert 5 times..."

    # Play sound 5 times
    for i in {1..5}; do
      afplay "$SOUND"
      sleep 0.5
    done

    echo "✓ Done!"
    exit 0
  fi

  echo "[$(date '+%H:%M:%S')] Waiting... $DOMAIN currently resolves to: ${CURRENT_IP:-'(no response)'}"
  sleep 10
done
