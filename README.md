# n8n Local Stack

This repository provides a simple, production-like Docker Compose setup to run [n8n](https://n8n.io/) locally, complete with PostgreSQL, Kafka, Zookeeper, Kafka UI, and Caddy for reverse proxying.

## Features

- **n8n**: Open-source workflow automation tool.
- **PostgreSQL**: Reliable database backend for n8n.
- **Kafka & Zookeeper**: Event streaming and queueing.
- **Kafka UI**: Web interface for managing Kafka topics and messages.
- **Caddy** (prod only): Modern web server and reverse proxy with automatic HTTPS.

---

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [`just` command runner](https://just.systems/man/en/) ([installation guide](https://just.systems/man/en/#installation))

> **Note:** `just` is a modern command runner, similar to Make, but focused on project automation. See the [official docs](https://just.systems/man/en/) for more details and installation instructions.

---

## Prepare the production environment

### 1. Create the volumes

In production mode, we choosed to use external volumes for the stack, because we want the volumes to be persistent and not accidentially deleted, by a wrong command.

Since the volumes hold all necessary data, we need to create them before starting the stack.

```bash
docker volume create caddy_data
docker volume create n8n_data
docker volume create n8n_local_files
docker volume create postgres_data
```

### 2. Setup DNS

In production mode, we use a Caddy reverse proxy to expose the services to the internet.

Caddy will expose the main services (kafka-ui, n8n) to subdomains of the domain you set in the `.env` file.

It is important to setup DNS records for the subdomains you want to use. Usually by setting an A record (ipv4) or / and AAAA record (ipv6) for the subdomain to the IP address of the server.

For example, if you want to use the domain `example.com` and the subdomain `kafka`, you need to setup the following DNS records:

```
kafka.example.com IN A 192.168.1.100
kafka.example.com IN AAAA 2001:db8::1
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/iamfj/n8n-stack.git
cd n8n-stack
```

### 2. Install `just` (if not already installed)

Follow the [official installation instructions](https://just.systems/man/en/#installation) for your platform. For example, on macOS:

```bash
brew install just
```

### 3. Configure Environment Variables

Copy the example environment file and adjust as needed:

```bash
cp .env.example .env
```

Edit `.env` to set your desired configuration (database passwords, domain, etc).

### 4. Start the Stack

You can use `just` to manage the stack easily:

```bash
just up            # Start the stack in dev mode
just up dev        # Start the stack in dev mode
just up prod       # Start the stack in production mode
```

To rebuild images:

```bash
just up rebuild        # Rebuild and start in dev mode
just up dev rebuild    # Rebuild and start in dev mode
just up prod rebuild   # Rebuild and start in production mode
```

---

## justfile Commands

The following commands are available via `just`:

| Command                | Description                                              |
|------------------------|----------------------------------------------------------|
| `just up`              | Start the stack (default: dev mode)                      |
| `just up prod`         | Start the stack in production mode                       |
| `just up rebuild`      | Start the stack and rebuild images (dev mode)            |
| `just down`            | Stop the stack (default: dev mode)                       |
| `just down prod`       | Stop the stack in production mode                        |
| `just logs n8n`        | Show logs for n8n                                        |
| `just logs kafka-ui`   | Show logs for kafka-ui                                   |
| `just logs kafka`      | Show logs for kafka                                      |
| `just logs zoo`        | Show logs for zookeeper                                  |
| `just logs postgres`   | Show logs for postgres                                   |
| `just clean`           | Remove all containers, images, and volumes (dev mode)    |
| `just clean prod`      | Remove all containers, images, and volumes (prod mode)   |
| `just pull`            | Pull latest images (dev mode)                            |
| `just pull prod`       | Pull latest images (prod mode)                           |
| `just restart`         | Restart the stack (dev mode)                             |
| `just restart prod`    | Restart the stack (prod mode)                            |
| `just update`          | Update images and restart the stack (dev mode)           |
| `just update prod`     | Update images and restart the stack (prod mode)          |
| `just`                 | List all available commands                              |

> **Tip:** You can always run `just` to see all available commands and their descriptions.

---

## Services

| Service     | Port(s)      | Description                                 |
|-------------|--------------|---------------------------------------------|
| n8n         | 5678         | Workflow automation UI/API                  |
| postgres    | 5432         | Database for n8n                            |
| kafka       | 9092, 29092  | Event streaming                             |
| zookeeper   | 2181         | Kafka dependency                            |
| kafka-ui    | 8080         | Web UI for Kafka                            |
| caddy       | 80, 443      | Reverse proxy (with HTTPS support)          |

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
├── justfile       # Project automation commands
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
just down
```

To remove all data (be careful!):

```bash
just clean
```

---

## Troubleshooting

- Check logs with `just logs <service>`.
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
