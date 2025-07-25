@echo off
echo Starting Private Web3 Development SDK for Windows...
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop for Windows
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not running
    echo Please start Docker Desktop
    pause
    exit /b 1
)

echo Docker is ready...
echo.

REM Set environment variables for Windows
set NEXTCLOUD_DATADIR=/run/desktop/mnt/host/c/web3-sdk-data
set NEXTCLOUD_MOUNT=/run/desktop/mnt/host/c/
set COMPOSE_PROJECT_NAME=web3-private-sdk

REM Create data directory on Windows
if not exist "C:\web3-sdk-data" mkdir "C:\web3-sdk-data"

echo Starting Private Web3 SDK with VPN protection...
docker-compose -f windows-compose.yaml up -d

echo.
echo ================================================
echo Private Web3 Development SDK is starting...
echo.
echo VPN Dashboard: https://localhost:8443
echo Web3 Development: http://localhost:8545
echo Nextcloud (optional): https://localhost:443
echo.
echo Wait for all containers to start (this may take a few minutes)
echo Check status with: docker-compose -f windows-compose.yaml ps
echo ================================================
echo.

pause