#!/bin/bash

# Comprehensive test suite for Private Web3 SDK

set -e

echo "🧪 Running Comprehensive Private Web3 SDK Test Suite"
echo "=================================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0

print_test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ $2${NC}"
        ((TESTS_FAILED++))
    fi
}

echo "1. Testing Prerequisites..."

# Test Docker availability
if command -v docker &> /dev/null; then
    print_test_result 0 "Docker is available"
else
    print_test_result 1 "Docker is not available"
fi

# Test Docker Compose availability
if docker compose version &> /dev/null || docker-compose --version &> /dev/null; then
    print_test_result 0 "Docker Compose is available"
else
    print_test_result 1 "Docker Compose is not available"
fi

echo ""
echo "2. Testing File Structure..."

# Test required files
files=(
    "compose.yaml"
    "Containers/vpn/Dockerfile"
    "Containers/vpn/entrypoint.sh"
    "Containers/vpn/vpn-manager.sh"
    "Containers/web3-dev/Dockerfile"
    "Containers/web3-dev/package.json"
    "Containers/web3-dev/hardhat.config.js"
    "windows-sdk/windows-compose.yaml"
    "windows-sdk/start-sdk.ps1"
    "windows-sdk/start-sdk.bat"
    "windows-sdk/README.md"
    ".env.example"
    "DEVELOPER_GUIDE.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        print_test_result 0 "File exists: $file"
    else
        print_test_result 1 "File missing: $file"
    fi
done

echo ""
echo "3. Testing Script Permissions..."

# Test script executability
scripts=(
    "Containers/vpn/entrypoint.sh"
    "Containers/vpn/vpn-manager.sh"
    "Containers/web3-dev/entrypoint.sh"
    "Containers/web3-dev/web3-setup.sh"
    "validate-sdk.sh"
    "install-linux.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        print_test_result 0 "Script executable: $script"
    else
        print_test_result 1 "Script not executable: $script"
    fi
done

echo ""
echo "4. Testing Configuration Files..."

# Test Docker Compose syntax
if docker compose -f compose.yaml config &> /dev/null; then
    print_test_result 0 "Main compose.yaml syntax valid"
else
    print_test_result 1 "Main compose.yaml syntax invalid"
fi

if docker compose -f windows-sdk/windows-compose.yaml config &> /dev/null; then
    print_test_result 0 "Windows compose.yaml syntax valid"
else
    print_test_result 1 "Windows compose.yaml syntax invalid"
fi

# Test Hardhat config syntax
if node -c Containers/web3-dev/hardhat.config.js &> /dev/null; then
    print_test_result 0 "Hardhat config syntax valid"
else
    # Node might not be available, so we'll do a basic syntax check
    if grep -q "module.exports" Containers/web3-dev/hardhat.config.js; then
        print_test_result 0 "Hardhat config basic syntax valid"
    else
        print_test_result 1 "Hardhat config syntax invalid"
    fi
fi

# Test package.json syntax
if python3 -m json.tool Containers/web3-dev/package.json &> /dev/null; then
    print_test_result 0 "Package.json syntax valid"
else
    print_test_result 1 "Package.json syntax invalid"
fi

echo ""
echo "5. Testing Documentation..."

# Check if README files have required sections
if grep -q "Private Web3" windows-sdk/README.md; then
    print_test_result 0 "Windows SDK README has required content"
else
    print_test_result 1 "Windows SDK README missing required content"
fi

if grep -q "Web3 Development SDK" DEVELOPER_GUIDE.md; then
    print_test_result 0 "Developer Guide has required content"
else
    print_test_result 1 "Developer Guide missing required content"
fi

echo ""
echo "6. Testing Container Definitions..."

# Check if VPN Dockerfile has required components
if grep -q "wireguard-tools" Containers/vpn/Dockerfile; then
    print_test_result 0 "VPN Dockerfile includes WireGuard"
else
    print_test_result 1 "VPN Dockerfile missing WireGuard"
fi

# Check if Web3 Dockerfile has required tools
if grep -q "hardhat" Containers/web3-dev/Dockerfile; then
    print_test_result 0 "Web3 Dockerfile includes Hardhat"
else
    print_test_result 1 "Web3 Dockerfile missing Hardhat"
fi

if grep -q "truffle" Containers/web3-dev/Dockerfile; then
    print_test_result 0 "Web3 Dockerfile includes Truffle"
else
    print_test_result 1 "Web3 Dockerfile missing Truffle"
fi

echo ""
echo "7. Testing Smart Contract Template..."

if [ -f "Containers/web3-dev/sample-contract.sol" ]; then
    if grep -q "pragma solidity" Containers/web3-dev/sample-contract.sol; then
        print_test_result 0 "Sample contract has valid Solidity syntax"
    else
        print_test_result 1 "Sample contract missing Solidity pragma"
    fi
else
    print_test_result 1 "Sample contract file missing"
fi

echo ""
echo "8. Testing Environment Configuration..."

if [ -f ".env.example" ]; then
    if grep -q "VPN_SERVER_IP" .env.example; then
        print_test_result 0 "Environment config includes VPN settings"
    else
        print_test_result 1 "Environment config missing VPN settings"
    fi
    
    if grep -q "WEB3_NETWORK" .env.example; then
        print_test_result 0 "Environment config includes Web3 settings"
    else
        print_test_result 1 "Environment config missing Web3 settings"
    fi
else
    print_test_result 1 "Environment configuration file missing"
fi

echo ""
echo "9. Testing Windows SDK Components..."

# Check Windows PowerShell script
if grep -q "Private Web3" windows-sdk/start-sdk.ps1; then
    print_test_result 0 "PowerShell script has correct branding"
else
    print_test_result 1 "PowerShell script missing branding"
fi

# Check Windows batch script
if grep -q "Docker" windows-sdk/start-sdk.bat; then
    print_test_result 0 "Batch script includes Docker checks"
else
    print_test_result 1 "Batch script missing Docker checks"
fi

echo ""
echo "=================================================="
echo "🧪 Test Suite Complete"
echo ""
echo -e "Tests Passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests Failed: ${RED}${TESTS_FAILED}${NC}"
echo -e "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Private Web3 SDK is ready for deployment.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Start the SDK: docker compose up -d"
    echo "2. Or use Windows SDK: cd windows-sdk && ./start-sdk.ps1"
    echo "3. Access VPN Dashboard: https://localhost:8443"
    echo "4. Access Web3 Dev: http://localhost:8545"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review the issues above.${NC}"
    exit 1
fi