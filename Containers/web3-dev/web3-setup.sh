#!/bin/bash

echo "Setting up Web3 development environment..."

# Initialize Hardhat project
if [ ! -f hardhat.config.js ]; then
    echo "Initializing Hardhat project..."
    npx hardhat init --force
fi

# Compile sample contracts
echo "Compiling contracts..."
npx hardhat compile

# Start local blockchain in background
echo "Starting local Ganache blockchain..."
ganache --host 0.0.0.0 --port 8545 --deterministic &

echo "Web3 development environment setup complete!"
echo "Local blockchain running on port 8545"
echo "Ready for Web3 development with privacy-focused VPN connection"