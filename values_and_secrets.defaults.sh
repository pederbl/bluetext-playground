#!/bin/bash
# Default values and secrets for development environment
# Run this script to set up default configuration for the stack

echo "Setting up default values and secrets for the stack..."

# Environment configuration
pt values set environment dev
pt values set config-manager-services couchbase,redpanda

# Web App configuration
pt values set web-app-port 3000
pt values set web-app-url http://localhost:5000

# API configuration
pt values set api-host localhost
pt values set api-port 4000

# Kong API Gateway configuration
pt values set kong-host localhost
pt values set kong-host-pt localhost
pt values set kong-port 5000
pt values set kong-admin-port 8001

# Curity Identity Provider configuration
pt values set curity-base-url http://localhost:8443
pt values set curity-agent-base-url http://localhost:5000

# PostgreSQL configuration
pt values set postgres-host postgres
pt values set postgres-port 5432
pt values set postgres-database myapp
pt secrets set postgres-username appuser
pt secrets set postgres-password changeme123

# Couchbase configuration
pt values set couchbase-host couchbase
pt values set couchbase-tls false
pt secrets set couchbase-username Administrator
pt secrets set couchbase-password password123

# Redpanda configuration
pt values set redpanda-host redpanda
pt values set redpanda-port 9092

echo "✅ Default values and secrets have been set!"
echo ""
echo "📝 Next steps:"
echo "1. Review and customize the values/secrets as needed"
echo "2. Run 'pt run stack' to start the complete application stack"
echo ""
echo "🔧 To customize values for your environment, create a local 'values_and_secrets.sh' file"
echo "   (this file is gitignored and won't be committed)"
