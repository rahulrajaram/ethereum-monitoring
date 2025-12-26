# Ethereum Node Monitoring Stack

A Docker-based Grafana + Prometheus monitoring solution for Ethereum nodes running Geth (execution client) and Prysm (consensus client).

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- **Pre-configured dashboards** for Geth and Prysm (downloaded from original sources)
- **Docker Compose** setup for easy deployment
- **LAN accessible** - monitor from any device on your network
- **Persistent storage** for metrics history
- **30-day retention** by default

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Geth and Prysm running with metrics enabled (see [Node Configuration](#node-configuration))
- `curl` installed (for downloading dashboards)

### 1. Clone the repository

```bash
git clone https://github.com/rahulrajaram/ethereum-monitoring.git
cd ethereum-monitoring
```

### 2. Run setup script

```bash
./setup.sh
```

This downloads the Grafana dashboards from their original sources and creates your `.env` file.

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
- **Default password:** Set in your `.env` file

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

Dashboards are downloaded from their original sources during setup:

### Geth Dashboard
- **Source:** [Grafana Labs #13877](https://grafana.com/grafana/dashboards/13877)
- **Metrics:** Peer connections, sync progress, chain head, database metrics, gas usage

### Prysm Dashboard (ETH Staking)
- **Source:** [GuillaumeMiralles/prysm-grafana-dashboard](https://github.com/GuillaumeMiralles/prysm-grafana-dashboard)
- **Metrics:** Head slot and epoch, finalized epoch, beacon peers, attestation statistics

## Directory Structure

```
.
├── setup.sh                 # Downloads dashboards and creates .env
├── docker-compose.yml       # Main compose (Docker network mode)
├── docker-compose.standalone.yml  # For non-Docker node setups
├── .env.example             # Template for environment variables
├── prometheus/
│   └── prometheus.yml       # Prometheus scrape configuration
└── grafana/
    ├── dashboards/          # Downloaded by setup.sh
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
| `GRAFANA_ADMIN_PASSWORD` | Grafana admin password | `ethereum` |
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

Re-run the setup script to download dashboards:
```bash
./setup.sh
docker compose restart grafana
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Note:** The Grafana dashboards are downloaded from third-party sources and are subject to their respective licenses:
- Geth Dashboard: [Grafana Labs](https://grafana.com/grafana/dashboards/13877)
- Prysm Dashboard: [GuillaumeMiralles](https://github.com/GuillaumeMiralles/prysm-grafana-dashboard)

## Acknowledgments

- [Geth](https://geth.ethereum.org/) - Go Ethereum
- [Prysm](https://prysmaticlabs.com/) - Ethereum Consensus Client
- [Grafana](https://grafana.com/) - Observability Platform
- [Prometheus](https://prometheus.io/) - Monitoring System
- Dashboard authors for their contributions to the community
