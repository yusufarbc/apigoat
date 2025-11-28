# All-in-One APIGOAT Container with Embedded MongoDB
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js, MongoDB, and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    wget \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add - \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update \
    && apt-get install -y mongodb-org \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PM2 globally for process management
RUN npm install -g pm2

# Create MongoDB data directory
RUN mkdir -p /data/db && chmod -R 777 /data/db

# Create app directory
WORKDIR /app

# Copy all source code
COPY . .

# Install dependencies for each API
RUN cd API1 && npm install --production && \
    cd ../API2 && npm install --production && \
    cd ../API3 && npm install --production && \
    cd ../API4 && npm install --production && \
    cd ../API5 && npm install --production && \
    cd ../API6 && npm install --production && \
    cd ../API7 && npm install --production && \
    cd ../API8 && npm install --production && \
    cd ../API9 && npm install --production && \
    cd ../API10 && npm install --production && \
    cd ../web && npm install --production

# Copy and set permissions for startup script
COPY docker-start-simple.sh /app/docker-start.sh
RUN chmod +x /app/docker-start.sh && mkdir -p /var/log

# Expose all ports (APIs + MongoDB)
EXPOSE 8000 8001 8002 8003 8004 8005 8006 8007 8008 8009 8010 27017

# Set default environment variables
ENV mongoDBURL="mongodb://localhost:27017/apigoat"
ENV OPENWEATHER_API_KEY="demo_key"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "require('http').get('http://localhost:8000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})" || exit 1

# Start MongoDB and all services
CMD ["/app/docker-start.sh"]
