#!/bin/bash
set -e

echo "Starting Web3 Development Environment..."

# Initialize project if not already done
if [ ! -f /workspace/.initialized ]; then
    echo "Initializing Web3 project..."
    /usr/local/bin/web3-setup.sh
    touch /workspace/.initialized
fi

# Set up development environment
export HARDHAT_NETWORK="development"
export NODE_ENV="development"

echo "Web3 development environment ready!"
echo "Available tools:"
echo "  - Hardhat: npx hardhat"
echo "  - Truffle: truffle"
echo "  - Ganache: ganache"
echo "  - Foundry: forge"
echo "  - Web3.js and Ethers.js available"

# Execute the command
exec "$@"