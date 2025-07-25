#!/bin/bash

# Validation script for Private Web3 SDK
echo "Validating Private Web3 SDK Components..."

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found"
    exit 1
fi

echo "✅ Docker found"

# Validate Dockerfile syntax
echo "Checking VPN Dockerfile..."
if docker build -t test-vpn-validation ./Containers/vpn --dry-run 2>/dev/null; then
    echo "✅ VPN Dockerfile syntax valid"
else
    echo "❌ VPN Dockerfile has issues"
fi

echo "Checking Web3 Dev Dockerfile..."
if docker build -t test-web3-validation ./Containers/web3-dev --dry-run 2>/dev/null; then
    echo "✅ Web3 Dev Dockerfile syntax valid"
else
    echo "❌ Web3 Dev Dockerfile has issues"
fi

# Validate compose files
echo "Checking main compose.yaml..."
if docker compose -f compose.yaml config &> /dev/null; then
    echo "✅ Main compose.yaml valid"
else
    echo "❌ Main compose.yaml has issues"
fi

echo "Checking Windows SDK compose..."
if docker compose -f windows-sdk/windows-compose.yaml config &> /dev/null; then
    echo "✅ Windows SDK compose valid"
else
    echo "❌ Windows SDK compose has issues"
fi

# Check if required files exist
files=(
    "Containers/vpn/Dockerfile"
    "Containers/vpn/entrypoint.sh"
    "Containers/vpn/vpn-manager.sh"
    "Containers/web3-dev/Dockerfile"
    "Containers/web3-dev/entrypoint.sh"
    "windows-sdk/start-sdk.bat"
    "windows-sdk/start-sdk.ps1"
    "windows-sdk/README.md"
)

echo "Checking required files..."
all_files_exist=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        all_files_exist=false
    fi
done

if $all_files_exist; then
    echo "🎉 All validation checks passed!"
    echo "Private Web3 SDK is ready for deployment"
else
    echo "❌ Some validation checks failed"
    exit 1
fi