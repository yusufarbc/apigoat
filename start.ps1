# APIGOAT - Single-Container Startup Script
# Builds and runs the all-in-one vulnerable lab container (MongoDB + APIs + Web)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  APIGOAT - OWASP Top 10 API Security  " -ForegroundColor Cyan
Write-Host "  Cloud-Native Docker Deployment       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed and running
Write-Host "[1/3] Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not found"
    }
    Write-Host "  ✓ Docker found: $dockerVersion" -ForegroundColor Green
    
    # Check if Docker daemon is running
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ✗ Docker daemon is not running!" -ForegroundColor Red
        Write-Host "  → Please start Docker Desktop and try again." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "  ✓ Docker daemon is running" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Docker is not installed!" -ForegroundColor Red
    Write-Host "  → Download Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Check if Docker Compose is available
Write-Host ""
Write-Host "[2/3] Checking existing container..." -ForegroundColor Yellow
if (docker ps -a --format "{{.Names}}" | Select-String -Pattern "apigoat-all" -Quiet) {
    Write-Host "  → Old container found. Stopping & removing..." -ForegroundColor Yellow
    docker stop apigoat-all 2>$null | Out-Null
    docker rm apigoat-all 2>$null | Out-Null
    Write-Host "  ✓ Cleaned previous container" -ForegroundColor Green
} else {
    Write-Host "  ✓ No previous container" -ForegroundColor Green
}

# Stop and remove existing containers (clean slate)
Write-Host ""
Write-Host "[3/3] Building single lab image..." -ForegroundColor Yellow
Write-Host "  → docker build -t yusufarbc/apigoat:all ." -ForegroundColor Cyan
docker build -t yusufarbc/apigoat:all .
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ Build failed" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Image built" -ForegroundColor Green

Write-Host "Starting container (ports 8000-8010 + 27017)..." -ForegroundColor Yellow
docker run -d --name apigoat-all -p 8000:8000 -p 8001:8001 -p 8002:8002 -p 8003:8003 -p 8004:8004 -p 8005:8005 -p 8006:8006 -p 8007:8007 -p 8008:8008 -p 8009:8009 -p 8010:8010 -p 27017:27017 yusufarbc/apigoat:all
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ Container start failed" -ForegroundColor Red
    exit 1
}

# Start all services with Docker Compose
Write-Host ""
Write-Host "[4/4] Starting APIGOAT services..." -ForegroundColor Yellow
Write-Host "  → Building images (this may take a few minutes on first run)..." -ForegroundColor Cyan

Start-Sleep -Seconds 5
if (docker ps --format "{{.Names}}" | Select-String -Pattern "apigoat-all" -Quiet) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✓ APIGOAT (single container) running " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Services available:" -ForegroundColor White
    Write-Host "  → Web Interface:  http://localhost:8000" -ForegroundColor Cyan
    Write-Host "  → API1 (BOLA):    http://localhost:8001" -ForegroundColor Cyan
    Write-Host "  → API2 (Auth):    http://localhost:8002" -ForegroundColor Cyan
    Write-Host "  → API3 (BOPLA):   http://localhost:8003" -ForegroundColor Cyan
    Write-Host "  → API4 (Resource):http://localhost:8004" -ForegroundColor Cyan
    Write-Host "  → API5 (Function):http://localhost:8005" -ForegroundColor Cyan
    Write-Host "  → API6 (Business):http://localhost:8006" -ForegroundColor Cyan
    Write-Host "  → API7 (SSRF):    http://localhost:8007" -ForegroundColor Cyan
    Write-Host "  → API8 (SecMisc): http://localhost:8008" -ForegroundColor Cyan
    Write-Host "  → API9 (Inventory):http://localhost:8009" -ForegroundColor Cyan
    Write-Host "  → API10 (Unsafe): http://localhost:8010" -ForegroundColor Cyan
    Write-Host "  → MongoDB:        mongodb://admin:apigoat123@localhost:27017" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Useful commands:" -ForegroundColor White
    Write-Host "  → View logs:      docker logs -f apigoat-all" -ForegroundColor Yellow
    Write-Host "  → Stop:           docker stop apigoat-all" -ForegroundColor Yellow
    Write-Host "  → Remove:         docker rm apigoat-all" -ForegroundColor Yellow
    Write-Host "  → Rebuild:        docker build -t yusufarbc/apigoat:all ." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opening web interface in browser..." -ForegroundColor Cyan
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:8000"
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ✗ Failed to start single container   " -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Check logs: docker logs apigoat-all" -ForegroundColor White
    Write-Host "  2. Verify ports 8000-8010, 27017 are free" -ForegroundColor White
    Write-Host "  3. Ensure Docker has enough resources (2GB+ RAM recommended)" -ForegroundColor White
    exit 1
}
