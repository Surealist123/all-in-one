#!/bin/bash

# Quick verification for Private Web3 SDK
echo "🔍 Quick Private Web3 SDK Verification"
echo "======================================"

# Check if key files exist
KEY_FILES=(
    "compose.yaml"
    "Containers/vpn/Dockerfile"
    "Containers/web3-dev/Dockerfile"
    "windows-sdk/windows-compose.yaml"
    "windows-sdk/start-sdk.ps1"
    "windows-sdk/README.md"
    "DEVELOPER_GUIDE.md"
)

echo "✅ Checking key files..."
for file in "${KEY_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (missing)"
        exit 1
    fi
done

echo ""
echo "✅ Checking Docker configuration..."
if docker compose -f compose.yaml config > /dev/null 2>&1; then
    echo "  ✓ Main compose.yaml valid"
else
    echo "  ✗ Main compose.yaml invalid"
    exit 1
fi

if docker compose -f windows-sdk/windows-compose.yaml config > /dev/null 2>&1; then
    echo "  ✓ Windows compose.yaml valid"
else
    echo "  ✗ Windows compose.yaml invalid"
    exit 1
fi

echo ""
echo "✅ Checking executable permissions..."
SCRIPTS=(
    "Containers/vpn/entrypoint.sh"
    "Containers/vpn/vpn-manager.sh"
    "Containers/web3-dev/entrypoint.sh"
    "validate-sdk.sh"
    "install-linux.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -x "$script" ]; then
        echo "  ✓ $script"
    else
        echo "  ✗ $script (not executable)"
        exit 1
    fi
done

echo ""
echo "🎉 All verification checks passed!"
echo ""
echo "The Private Web3 SDK is ready for deployment:"
echo ""
echo "Standard deployment:"
echo "  docker compose up -d"
echo ""
echo "Windows SDK:"
echo "  cd windows-sdk"
echo "  start-sdk.bat"
echo "  # or"
echo "  ./start-sdk.ps1 -Action start"
echo ""
echo "Access points after startup:"
echo "  🛡️  VPN Dashboard:    https://localhost:8443"
echo "  🚀 Web3 Development: http://localhost:8545"
echo "  📁 Nextcloud:        https://localhost:443"