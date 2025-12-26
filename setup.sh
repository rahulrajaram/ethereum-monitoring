#!/bin/bash
#
# Ethereum Node Monitoring - Setup Script
#
# Prepares the monitoring stack for first use.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Ethereum Node Monitoring Setup ==="
echo ""

# Create .env from example if it doesn't exist
echo "[1/1] Checking environment file..."
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
echo "Included dashboards:"
echo "  - Geth Dashboard (Prometheus metrics)"
echo "  - Prysm Beacon Node (Prometheus metrics)"
echo ""
