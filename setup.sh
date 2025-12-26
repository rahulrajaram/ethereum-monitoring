#!/bin/bash
#
# Ethereum Node Monitoring - Setup Script
#
# This script downloads Grafana dashboards from their original sources
# and prepares the monitoring stack for first use.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DASHBOARD_DIR="$SCRIPT_DIR/grafana/dashboards"

echo "=== Ethereum Node Monitoring Setup ==="
echo ""

# Create dashboards directory if it doesn't exist
mkdir -p "$DASHBOARD_DIR"

# Download Geth dashboard
echo "[1/3] Downloading Geth dashboard..."
echo "      Source: https://grafana.com/grafana/dashboards/13877"
curl -sfL "https://grafana.com/api/dashboards/13877/revisions/1/download" \
    -o "$DASHBOARD_DIR/geth.json"
echo "      Done: geth.json"

# Download Prysm dashboard
echo "[2/3] Downloading Prysm dashboard..."
echo "      Source: https://github.com/GuillaumeMiralles/prysm-grafana-dashboard"
curl -sfL "https://raw.githubusercontent.com/GuillaumeMiralles/prysm-grafana-dashboard/master/less_10_validators.json" \
    -o "$DASHBOARD_DIR/prysm.json"
echo "      Done: prysm.json"

# Create .env from example if it doesn't exist
echo "[3/3] Checking environment file..."
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    if [ -f "$SCRIPT_DIR/.env.example" ]; then
        cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
        echo "      Created .env from .env.example"
        echo "      IMPORTANT: Edit .env to change the default password!"
    fi
else
    echo "      .env already exists, skipping"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit prometheus/prometheus.yml with your Geth/Prysm endpoints"
echo "  2. Edit .env to set your Grafana admin password"
echo "  3. Run: docker compose up -d"
echo "  4. Open: http://localhost:3000"
echo ""
echo "Dashboard attributions:"
echo "  - Geth: https://grafana.com/grafana/dashboards/13877"
echo "  - Prysm: https://github.com/GuillaumeMiralles/prysm-grafana-dashboard"
echo ""
