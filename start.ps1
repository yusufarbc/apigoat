# APIGOAT - Cloud-Native Startup Script
# One-Click Docker Compose Launcher for Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  APIGOAT - OWASP Top 10 API Security  " -ForegroundColor Cyan
Write-Host "  Cloud-Native Docker Deployment       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed and running
Write-Host "[1/4] Checking Docker..." -ForegroundColor Yellow
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
Write-Host "[2/4] Checking Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker compose version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker Compose not found"
    }
    Write-Host "  ✓ Docker Compose found: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Docker Compose is not available!" -ForegroundColor Red
    Write-Host "  → Please install Docker Desktop (includes Compose)" -ForegroundColor Yellow
    exit 1
}

# Stop and remove existing containers (clean slate)
Write-Host ""
Write-Host "[3/4] Cleaning up old containers..." -ForegroundColor Yellow
docker compose down --remove-orphans 2>&1 | Out-Null
Write-Host "  ✓ Old containers cleaned" -ForegroundColor Green

# Start all services with Docker Compose
Write-Host ""
Write-Host "[4/4] Starting APIGOAT services..." -ForegroundColor Yellow
Write-Host "  → Building images (this may take a few minutes on first run)..." -ForegroundColor Cyan

docker compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✓ APIGOAT is running successfully!   " -ForegroundColor Green
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
    Write-Host "  → View logs:      docker compose logs -f" -ForegroundColor Yellow
    Write-Host "  → Stop services:  docker compose down" -ForegroundColor Yellow
    Write-Host "  → Restart:        docker compose restart" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opening web interface in browser..." -ForegroundColor Cyan
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:8000"
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ✗ Failed to start APIGOAT            " -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Check logs: docker compose logs" -ForegroundColor White
    Write-Host "  2. Verify ports 8000-8010, 27017 are free" -ForegroundColor White
    Write-Host "  3. Ensure Docker has enough resources (4GB+ RAM recommended)" -ForegroundColor White
    exit 1
}
