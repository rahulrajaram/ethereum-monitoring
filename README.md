# Ethereum Node Monitoring Stack

A Docker-based Grafana + Prometheus monitoring solution for Ethereum nodes running Geth (execution client) and Prysm (consensus client).

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- **Pre-configured Prometheus dashboards** for Geth and Prysm
- **Docker Compose** setup for easy deployment
- **LAN accessible** - monitor from any device on your network
- **Persistent storage** for metrics history
- **30-day retention** by default

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Geth and Prysm running with metrics enabled (see [Node Configuration](#node-configuration))

### 1. Clone the repository

```bash
git clone https://github.com/rahulrajaram/ethereum-monitoring.git
cd ethereum-monitoring
```

### 2. Run setup script

```bash
./setup.sh
```

This creates your `.env` file from the template.

### 3. Configure your environment

Edit `.env` to change the default password:

```bash
GRAFANA_ADMIN_PASSWORD=your-secure-password
```

### 4. Update Prometheus targets

Edit `prometheus/prometheus.yml` to point to your Geth and Prysm instances:

```yaml
scrape_configs:
  - job_name: 'geth'
    static_configs:
      - targets: ['YOUR_GETH_HOST:6060']

  - job_name: 'prysm-beacon'
    static_configs:
      - targets: ['YOUR_PRYSM_HOST:8080']
```

### 5. Start the stack

```bash
docker compose up -d
```

### 6. Access Grafana

Open `http://YOUR_SERVER_IP:3000` in your browser.

- **Default username:** `admin`
- **Default password:** Set in your `.env` file (default: `changeme`)

## Node Configuration

### Geth

Add these flags to your Geth startup command:

```bash
--metrics \
--metrics.addr 0.0.0.0 \
--metrics.port 6060
```

### Prysm

Add these flags to your Prysm beacon node startup command:

```bash
--monitoring-host=0.0.0.0 \
--monitoring-port=8080
```

## Dashboards

Custom Prometheus-compatible dashboards are included:

### Geth Dashboard
- **Metrics:** Head block, peer connections (total/inbound/outbound), chain data size, transaction pool, CPU load, RPC requests

### Prysm Beacon Node Dashboard
- **Metrics:** Head slot, finalized/justified epochs, slots behind network, peer connections, attestations, active validators, reorgs

## Directory Structure

```
.
├── setup.sh                 # Creates .env file
├── docker-compose.yml       # Main compose (Docker network mode)
├── docker-compose.standalone.yml  # For non-Docker node setups
├── .env.example             # Template for environment variables
├── prometheus/
│   └── prometheus.yml       # Prometheus scrape configuration
└── grafana/
    ├── dashboards/          # Pre-configured Prometheus dashboards
    │   ├── geth.json
    │   └── prysm.json
    └── provisioning/
        ├── datasources/
        │   └── datasources.yml
        └── dashboards/
            └── dashboards.yml
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GRAFANA_ADMIN_USER` | Grafana admin username | `admin` |
| `GRAFANA_ADMIN_PASSWORD` | Grafana admin password | `changeme` |
| `PROMETHEUS_RETENTION` | Metrics retention period | `30d` |
| `GRAFANA_PORT` | Grafana web UI port | `3000` |
| `PROMETHEUS_PORT` | Prometheus web UI port | `9090` |

### Network Modes

**Option 1: External network (default)**

If your Geth/Prysm containers are on an existing Docker network:

```yaml
networks:
  eth-net:
    external: true
```

**Option 2: Standalone**

If monitoring external hosts or non-Docker nodes, use the standalone compose file:

```bash
docker compose -f docker-compose.standalone.yml up -d
```

## Troubleshooting

### No data in dashboards

1. Check Prometheus targets: `http://YOUR_SERVER_IP:9090/targets`
2. Verify metrics endpoints are accessible:
   ```bash
   curl http://GETH_HOST:6060/debug/metrics/prometheus
   curl http://PRYSM_HOST:8080/metrics
   ```

### Permission denied errors

Ensure config files are readable:
```bash
chmod 644 prometheus/prometheus.yml
chmod -R 644 grafana/provisioning/*/*.yml
```

### Dashboards not appearing

Restart Grafana to reload dashboards:
```bash
docker compose restart grafana
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Geth](https://geth.ethereum.org/) - Go Ethereum
- [Prysm](https://prysmaticlabs.com/) - Ethereum Consensus Client
- [Grafana](https://grafana.com/) - Observability Platform
- [Prometheus](https://prometheus.io/) - Monitoring System
