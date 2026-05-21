# Observability Lab

A complete, cross-platform environment for learning and testing monitoring systems (Observability).
This lab is based on the popular open-source stack (Grafana, Prometheus, Loki) and is designed for deep analysis of logs, container hardware metrics,
and PostgreSQL database performance.

The environment is built around the Infrastructure as Code principle and utilizes Docker Named Volumes. 
This ensures that it runs flawlessly and without permission conflicts across Windows, Linux, and macOS.

## Architecture & Components

* Monitoring Target: PostgreSQL (with the pg_stat_statements module enabled for comprehensive query analysis).
* Visualization: Grafana (pre-configured with ready-to-use data sources and dashboards).
* Metrics: Prometheus, cAdvisor (container metrics), Node Exporter (host metrics), and Postgres Exporter.
* Logs: Loki (log aggregation) and Grafana Alloy (agent for collecting Docker logs).

## Network Ports Mapping

Below is the complete list of network ports used across the stack, including both host-exposed ports and internal container network ports:

* Grafana: 3000 (Exposed to host)
* Prometheus: 9090 (Exposed to host)
* Loki: 3100 (Exposed to host)
* Grafana Alloy: 12345 (Exposed to host)
* cAdvisor: 8080 (Exposed to host)
* PostgreSQL: 5432 (Exposed to host)
* Node Exporter: 9100 (Internal to monitoring_net)
* Postgres Exporter: 9187 (Internal to monitoring_net)

## Quick Start

### Prerequisites
* Docker and Docker Compose installed (e.g., Docker Desktop for Windows/Mac or Docker Engine for Linux).

### Running the Lab

1. Clone the repository and navigate to the project directory:
   git clone https://github.com/mStefn/observability_lab.git
   cd observability_lab
   
Run the setup script (this will automatically clean up old containers and start the new ones):
chmod +x setup.sh
./setup.sh
(Alternatively, you can simply run: docker compose up -d)

Open your browser and access Grafana:
URL: http://localhost:3000

Login: admin
Password: admin

Live Demo & Stress Test
The lab includes a built-in demo_load.sh script that allows you to test the monitoring setup under heavy combat-like conditions.
The script interactively generates:
Cyber Attacks: Invalid login attempts and brute-force attacks (generating FATAL logs in the Loki/Security panel).
Extreme Hardware Load: Triggers the pgbench benchmark to max out CPU, RAM, and Disk I/O (visible in the cAdvisor/Prometheus panels).
Inefficient SQL Code: Injects slow queries and intentional delays to simulate a poorly optimized application (visible in database latency statistics).

How to run the test?
From the root directory of the project, simply run:

chmod +x demo_load.sh
./demo_load.sh
Follow the on-screen instructions and watch live as Grafana reacts to the anomalies!

Environment Cleanup
To completely remove the lab (including all saved database data and volumes):

docker compose down --volumes --remove-orphans
