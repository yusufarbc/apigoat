#!/bin/bash
set -e

echo "🐐 =========================================="
echo "🐐  APIGOAT - OWASP API Top 10 2023"
echo "🐐  Vulnerable API Training Platform"
echo "🐐 =========================================="
echo ""

# Start MongoDB in the background
echo "📦 Starting MongoDB..."
mkdir -p /data/db
mongod --fork --logpath /var/log/mongodb.log --bind_ip_all

# Wait for MongoDB to be ready
echo "⏳ Waiting for MongoDB to start..."
for i in {1..30}; do
  if mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; then
    echo "✅ MongoDB is ready!"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "❌ MongoDB failed to start in time"
    exit 1
  fi
  sleep 1
done

# Set default environment variables
export mongoDBURL=${mongoDBURL:-"mongodb://localhost:27017/apigoat"}
export OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY:-"demo_key"}
export PORT_WEB=${PORT_WEB:-8000}
export PORT_API1=${PORT_API1:-8001}
export PORT_API2=${PORT_API2:-8002}
export PORT_API3=${PORT_API3:-8003}
export PORT_API4=${PORT_API4:-8004}
export PORT_API5=${PORT_API5:-8005}
export PORT_API6=${PORT_API6:-8006}
export PORT_API7=${PORT_API7:-8007}
export PORT_API8=${PORT_API8:-8008}
export PORT_API9=${PORT_API9:-8009}
export PORT_API10=${PORT_API10:-8010}
export JWT_KEY1=${JWT_KEY1:-"api1"}
export JWT_KEY2=${JWT_KEY2:-"api2"}
export JWT_KEY3=${JWT_KEY3:-"api3"}
export JWT_KEY4=${JWT_KEY4:-"api4"}
export JWT_KEY5=${JWT_KEY5:-"api5"}
export JWT_KEY6=${JWT_KEY6:-"api6"}
export JWT_KEY7=${JWT_KEY7:-"api7"}
export JWT_KEY8=${JWT_KEY8:-"api8"}
export JWT_KEY9=${JWT_KEY9:-"api9"}
export JWT_KEY10=${JWT_KEY10:-"api10"}

echo ""
echo "🎯 Configuration:"
echo "   MongoDB:    $mongoDBURL"
echo "   Web UI:     http://localhost:$PORT_WEB"
echo "   API Range:  http://localhost:8001-8010"
echo ""

# Start all services in background
echo "🚀 Starting all API services..."

(cd /app/web && node app.js) > /var/log/web.log 2>&1 &
(cd /app/API1 && node app.js) > /var/log/api1.log 2>&1 &
(cd /app/API2 && node app.js) > /var/log/api2.log 2>&1 &
(cd /app/API3 && node app.js) > /var/log/api3.log 2>&1 &
(cd /app/API4 && node app.js) > /var/log/api4.log 2>&1 &
(cd /app/API5 && node app.js) > /var/log/api5.log 2>&1 &
(cd /app/API6 && node app.js) > /var/log/api6.log 2>&1 &
(cd /app/API7 && node app.js) > /var/log/api7.log 2>&1 &
(cd /app/API8 && node app.js) > /var/log/api8.log 2>&1 &
(cd /app/API9 && node app.js) > /var/log/api9.log 2>&1 &
(cd /app/API10 && node app.js) > /var/log/api10.log 2>&1 &

# Wait a bit for services to start
sleep 3

echo ""
echo "✅ All services started!"
echo ""
echo "🌐 Access the platform:"
echo "   Web Interface: http://localhost:8000"
echo "   API1-API10:    http://localhost:8001-8010"
echo ""
echo "📋 View logs:"
echo "   docker logs -f apigoat"
echo ""

# Keep container running and show logs
tail -f /var/log/*.log
