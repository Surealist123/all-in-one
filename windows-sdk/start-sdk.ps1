# Private Web3 Development SDK for Windows
# PowerShell version with enhanced error handling

param(
    [string]$Action = "start",
    [string]$DataDir = "C:\web3-sdk-data",
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

function Write-Banner {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "    Private Web3 Development SDK" -ForegroundColor Green
    Write-Host "    Privacy-First Blockchain Development" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Yellow
    
    # Check Docker
    try {
        $dockerVersion = docker --version
        Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Docker not found. Please install Docker Desktop for Windows." -ForegroundColor Red
        throw "Docker is required"
    }
    
    # Check if Docker is running
    try {
        docker info | Out-Null
        Write-Host "✓ Docker is running" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
        throw "Docker is not running"
    }
    
    # Check Docker Compose
    try {
        docker-compose --version | Out-Null
        Write-Host "✓ Docker Compose available" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Docker Compose not found" -ForegroundColor Red
        throw "Docker Compose is required"
    }
}

function New-DataDirectory {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        Write-Host "Creating data directory: $Path" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "✓ Data directory created" -ForegroundColor Green
    } else {
        Write-Host "✓ Data directory exists: $Path" -ForegroundColor Green
    }
}

function Start-SDK {
    Write-Banner
    Test-Prerequisites
    New-DataDirectory -Path $DataDir
    
    # Set environment variables
    $env:NEXTCLOUD_DATADIR = "/run/desktop/mnt/host/c/web3-sdk-data"
    $env:NEXTCLOUD_MOUNT = "/run/desktop/mnt/host/c/"
    $env:COMPOSE_PROJECT_NAME = "web3-private-sdk"
    
    Write-Host "Starting Private Web3 SDK with VPN protection..." -ForegroundColor Yellow
    Write-Host "This may take several minutes on first run..." -ForegroundColor Yellow
    
    try {
        docker-compose -f windows-compose.yaml up -d
        
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Green
        Write-Host "SDK Started Successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Access Points:" -ForegroundColor Cyan
        Write-Host "  🛡️  VPN Dashboard:    https://localhost:8443" -ForegroundColor White
        Write-Host "  🚀 Web3 Development: http://localhost:8545" -ForegroundColor White
        Write-Host "  📁 Nextcloud:        https://localhost:443" -ForegroundColor White
        Write-Host ""
        Write-Host "Development Commands:" -ForegroundColor Cyan
        Write-Host "  docker exec -it web3-sdk-dev bash" -ForegroundColor White
        Write-Host "  npx hardhat console --network development" -ForegroundColor White
        Write-Host ""
        Write-Host "Status: ./start-sdk.ps1 -Action status" -ForegroundColor Cyan
        Write-Host "Stop:   ./start-sdk.ps1 -Action stop" -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Green
        
    }
    catch {
        Write-Host "Error starting SDK: $_" -ForegroundColor Red
        throw
    }
}

function Stop-SDK {
    Write-Host "Stopping Private Web3 Development SDK..." -ForegroundColor Yellow
    
    try {
        docker-compose -f windows-compose.yaml down
        Write-Host "✓ SDK stopped successfully" -ForegroundColor Green
        Write-Host "Data preserved in: $DataDir" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Error stopping SDK: $_" -ForegroundColor Red
        throw
    }
}

function Get-SDKStatus {
    Write-Host "SDK Status:" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        docker-compose -f windows-compose.yaml ps
        Write-Host ""
        
        # Check individual services
        $services = @(
            @{Name="VPN"; Container="web3-sdk-vpn"; Port="51820"},
            @{Name="Web3 Dev"; Container="web3-sdk-dev"; Port="8545"},
            @{Name="Nextcloud"; Container="nextcloud-aio-mastercontainer"; Port="8443"}
        )
        
        foreach ($service in $services) {
            $running = docker ps --filter "name=$($service.Container)" --format "{{.Names}}" 2>$null
            if ($running) {
                Write-Host "✓ $($service.Name) - Running" -ForegroundColor Green
            } else {
                Write-Host "✗ $($service.Name) - Stopped" -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host "Error checking status: $_" -ForegroundColor Red
    }
}

function Show-Logs {
    Write-Host "Showing SDK logs..." -ForegroundColor Yellow
    docker-compose -f windows-compose.yaml logs -f
}

# Main execution
try {
    switch ($Action.ToLower()) {
        "start" { Start-SDK }
        "stop" { Stop-SDK }
        "status" { Get-SDKStatus }
        "logs" { Show-Logs }
        default {
            Write-Host "Usage: ./start-sdk.ps1 -Action [start|stop|status|logs]" -ForegroundColor Yellow
            Write-Host "Options:" -ForegroundColor Cyan
            Write-Host "  -DataDir <path>  : Custom data directory (default: C:\web3-sdk-data)" -ForegroundColor White
            Write-Host "  -Verbose         : Enable verbose output" -ForegroundColor White
        }
    }
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}