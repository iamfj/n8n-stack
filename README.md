# n8n Local Stack

This repository provides a simple, production-like Docker Compose setup to run [n8n](https://n8n.io/) locally, complete with PostgreSQL, Kafka, Zookeeper, Kafka UI, and Caddy for reverse proxying.

## Features

- **n8n**: Open-source workflow automation tool.
- **PostgreSQL**: Reliable database backend for n8n.
- **Kafka & Zookeeper**: Event streaming and queueing.
- **Kafka UI**: Web interface for managing Kafka topics and messages.
- **Caddy**: Modern web server and reverse proxy with automatic HTTPS.

---

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/iamfj/n8n-stack.git
cd n8n-stack
```

### 2. Configure Environment Variables

Copy the example environment file and adjust as needed:

```bash
cp .env.example .env
```

Edit `.env` to set your desired configuration (database passwords, domain, etc).

### 3. Start the Stack

```bash
docker compose up -d --build
```

This will build and start all services in the background.

---

## Services

| Service     | Port(s)      | Description                                 |
|-------------|--------------|---------------------------------------------|
| n8n         | 5678         | Workflow automation UI/API                  |
| PostgreSQL  | 5432         | Database for n8n                            |
| Kafka       | 9092, 29092  | Event streaming                             |
| Zookeeper   | 2181         | Kafka dependency                            |
| Kafka UI    | 8080         | Web UI for Kafka                            |
| Caddy       | 80, 443      | Reverse proxy (with HTTPS support)          |

---

## File Structure

```
.
├── caddy/         # Caddy reverse proxy config and Dockerfile
├── n8n/           # n8n custom Dockerfile and credentials
├── postgres/      # PostgreSQL init scripts
├── compose.yml    # Docker Compose configuration
├── .env           # Environment variables (user-specific)
├── .env.example   # Example environment file
└── README.md      # This file
```

---

## Usage

- **n8n UI**: [http://localhost:5678](http://localhost:5678)
- **Kafka UI**: [http://localhost:8080](http://localhost:8080)

> **Note:** Caddy will expose services on ports 80/443 if you configure a domain and set up DNS.

---

## Customization

- **n8n**: Place custom credentials in `n8n/credentials.json`.
- **PostgreSQL**: Edit `postgres/init.sql` for custom DB setup.
- **Caddy**: Adjust `caddy/Containerfile` and configs for your domain.

---

## Stopping and Removing

To stop the stack:

```bash
docker compose down
```

To remove all data (be careful!):

```bash
docker compose down -v
```

---

## Troubleshooting

- Check logs with `docker compose logs -f <service>`.
- Ensure ports are not in use by other applications.
- For permission issues, ensure your user can access Docker.

---

## Contributing

Contributions are welcome! Please open issues or pull requests.

---

## License

[MIT](LICENSE) (or your preferred license)

---

## Credits

- [n8n](https://n8n.io/)
- [PostgreSQL](https://www.postgresql.org/)
- [Kafka](https://kafka.apache.org/)
- [Caddy](https://caddyserver.com/)
- [Kafka UI](https://github.com/provectus/kafka-ui)
