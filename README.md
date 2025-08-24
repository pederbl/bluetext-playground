# Complete Application Stack Template

This Polytope template provides a comprehensive application stack with all the essential components for a modern web application, including frontend, backend, API gateway, identity management, databases, and messaging.

## Stack Components

The `stack` template includes the following modules:

- **🌐 React Web App** - Frontend application built with React and Bun
- **🐍 Python API** - Backend API server with Python
- **🦍 Kong API Gateway** - API gateway for routing and middleware
- **🔐 Curity Identity Provider** - Identity and access management
- **🐘 PostgreSQL** - Relational database
- **📊 Couchbase** - NoSQL document database
- **🔴 Redpanda** - Kafka-compatible streaming platform
- **⚙️ Config Manager** - Manages database and messaging configurations

## Quick Start

### 1. Set Up Configuration

Run the default configuration script to set up values and secrets:

```bash
./values_and_secrets.defaults.sh
```

This sets up development defaults. For production or custom environments, create your own `values_and_secrets.sh` file (this file is gitignored).

### 2. Generate Module Code

The stack requires boilerplate code for some modules. Generate them using:

```bash
# Generate React web app boilerplate
pt run --non-interactive "boilerplate{source-path: https://github.com/bluetext-io/boilerplate-react-web-app, target-path: modules/web-app}"

# Generate Python API boilerplate
pt run --non-interactive "boilerplate{source-path: https://github.com/bluetext-io/boilerplate-python-api, target-path: modules/api}"

# Generate Curity Identity Provider boilerplate
pt run --non-interactive "boilerplate{source-path: https://github.com/bluetext-io/boilerplate-curity-identity-provider, target-path: modules/curity}"
```

### 3. Start the Stack

```bash
pt run stack
```

This will start all services concurrently. Services will be available at:

- **Web App**: http://localhost:3000
- **API Gateway**: http://localhost:5000
- **Kong Admin**: http://localhost:8001
- **Curity Admin**: http://localhost:8443

## Architecture

### Service Communication

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  React App  │───▶│ Kong Gateway │───▶│ Python API  │
│   :3000     │    │    :5000     │    │    :4000    │
└─────────────┘    └──────────────┘    └─────────────┘
                           │                    │
                           ▼                    ▼
                   ┌──────────────┐    ┌─────────────┐
                   │   Curity     │    │ PostgreSQL  │
                   │    :8443     │    │    :5432    │
                   └──────────────┘    └─────────────┘
                                              │
                   ┌──────────────┐    ┌─────────────┐
                   │  Couchbase   │    │  Redpanda   │
                   │    :8091     │    │    :9092    │
                   └──────────────┘    └─────────────┘
                           │                    │
                           └────────┬───────────┘
                                    ▼
                           ┌──────────────┐
                           │Config Manager│
                           └──────────────┘
```

### Data Flow

1. **Frontend** (React) serves the user interface
2. **Kong Gateway** routes requests and handles CORS
3. **Python API** processes business logic
4. **Curity** manages authentication and authorization
5. **PostgreSQL** stores relational data
6. **Couchbase** handles document storage and caching
7. **Redpanda** manages event streaming and messaging
8. **Config Manager** initializes and configures databases and topics

## Configuration

### Environment Variables

All configuration is managed through Polytope values and secrets:

#### Values (Non-sensitive)
- `environment` - Target environment (dev, test, staging, prod)
- `web-app-port`, `api-port`, `kong-port` - Service ports
- `postgres-host`, `couchbase-host`, `redpanda-host` - Service hostnames
- Database and messaging configuration

#### Secrets (Sensitive)
- `postgres-username`, `postgres-password` - Database credentials
- `couchbase-username`, `couchbase-password` - Couchbase credentials
- Other authentication tokens and keys

### Database Configuration

#### Couchbase
Buckets, scopes, and collections are configured in `modules/config-manager/couchbase.yaml`:
- `main` bucket for application data (users, sessions, documents)
- `cache` bucket for temporary data
- Environment-specific scaling and retention policies

#### Redpanda Topics
Topics are configured in `modules/config-manager/redpanda.yaml`:
- `user-events` - User activity tracking
- `api-logs` - API request logging
- `notifications` - User notifications
- `session-events` - Session management
- `system-metrics` - System monitoring

### API Gateway Routes

Kong is configured in `modules/kong/kong.yml` with routes for:
- `/` → React Web App
- `/api` → Python API
- `/oauth`, `/authn`, `/admin` → Curity Identity Provider

## Development

### Adding Dependencies

Use the appropriate code generation modules:

```bash
# Add npm packages to React app
pt run "add-package-npm{module-path: modules/web-app, packages: [axios, react-router-dom]}"

# Add Python packages to API
pt run "add-package-python{module-path: modules/api, packages: [fastapi, sqlalchemy]}"
```

### Database Access

#### PostgreSQL
```python
# Connection parameters
host = "postgres"
port = 5432
database = os.getenv("DATABASE_NAME")
user = os.getenv("DATABASE_USER")
password = os.getenv("DATABASE_PASSWORD")
```

#### Couchbase
```python
# Connection with retry logic
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator

auth = PasswordAuthenticator(
    os.getenv("COUCHBASE_USERNAME"),
    os.getenv("COUCHBASE_PASSWORD")
)
cluster = Cluster(f"couchbase://{os.getenv('COUCHBASE_HOST')}", auth)
```

#### Redpanda/Kafka
```python
# Producer/Consumer setup
from kafka import KafkaProducer, KafkaConsumer

producer = KafkaProducer(
    bootstrap_servers=f"{os.getenv('REDPANDA_HOST')}:{os.getenv('REDPANDA_PORT')}"
)
```

## Production Deployment

### Environment-Specific Configuration

1. Create production values and secrets:
```bash
pt values set environment prod
pt values set web-app-port 80
pt values set kong-port 443
# ... other production values
```

2. Update database configurations in `modules/config-manager/` for production scaling

3. Configure proper authentication (remove `trust` method for PostgreSQL)

### Security Considerations

- Use strong passwords for all database credentials
- Configure proper CORS origins for production domains
- Enable TLS/SSL for all external communications
- Review and harden Curity Identity Provider configuration
- Set up proper backup strategies for persistent volumes

## Troubleshooting

### Common Issues

1. **Services not starting**: Check that all values and secrets are set
2. **Connection failures**: Services may take time to initialize, especially Couchbase (up to 10 minutes)
3. **Port conflicts**: Ensure configured ports are available on your system

### Logs and Monitoring

```bash
# View logs for specific services
pt logs web-app
pt logs api
pt logs kong

# Check service status
pt status
```

## File Structure

```
├── polytope.yml                    # Main Polytope configuration
├── values_and_secrets.defaults.sh  # Default configuration script
├── modules/
│   ├── kong/
│   │   └── kong.yml                # Kong gateway configuration
│   └── config-manager/
│       ├── config.yaml             # Config manager settings
│       ├── couchbase.yaml          # Couchbase bucket/collection config
│       └── redpanda.yaml           # Redpanda topic configuration
└── README.md                       # This file
```

## Contributing

When modifying the stack:

1. Follow Bluetext blueprint patterns for each service type
2. Use persistent volumes for all stateful services
3. Configure environment-specific scaling in config files
4. Update this README with any architectural changes

## Support

For issues with:
- **Polytope**: Check the Polytope documentation
- **Bluetext**: Refer to blueprint-specific documentation
- **Individual services**: Consult service-specific documentation

---

**Note**: This stack is designed for development and can be scaled for production use by adjusting the environment-specific configurations in the config files.
