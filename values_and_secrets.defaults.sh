#!/bin/bash
# Default values and secrets for development

echo "Setting up default values and secrets for the stack..."

# Values for API
pt values set api-host localhost
pt values set api-port 4000

# Values for Web App
pt values set web-app-port 3000

# Values for Kong API Gateway
pt values set kong-port 8000
pt values set kong-admin-port 8001

# Values for Curity Identity Server
pt values set curity-base-url http://localhost:8443
pt values set web-app-url http://localhost:5000
pt values set curity-agent-base-url http://localhost:5000

# Values and secrets for PostgreSQL
pt values set postgres-host postgres
pt values set postgres-port 5432
pt values set postgres-database idsvr
pt secrets set postgres-username admin
pt secrets set postgres-password password

echo "Default values and secrets have been set up successfully!"
echo ""
echo "You can now run the stack with: pt run stack"
echo ""
echo "Services will be available at:"
echo "- Kong API Gateway: http://localhost:5000"
echo "- Kong Admin API: http://localhost:8001"
echo "- Curity Identity Server: http://localhost:8443"
echo "- API (via Kong): http://localhost:5000/api"
echo "- Web App (via Kong): http://localhost:5000"
echo ""
echo "Direct service access:"
echo "- API: http://localhost:4000"
echo "- Web App: http://localhost:3000"
echo "- PostgreSQL: postgres:5432 (from within containers)"
echo ""
echo "Database connection details:"
echo "- Host: postgres (from containers) or localhost (external)"
echo "- Port: 5432"
echo "- Database: myapp"
echo "- Username: appuser"
echo "- Password: secure_dev_password_123"
