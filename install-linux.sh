#!/bin/bash

# Installation script for Private Web3 SDK on Ubuntu/Debian

set -e

echo "===========================================" 
echo "Private Web3 SDK Installation Script"
echo "Installing dependencies and setting up environment"
echo "===========================================" 

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root for security reasons" 
   exit 1
fi

# Update system
echo "Updating system packages..."
sudo apt update

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed. Please log out and log back in for group changes to take effect."
fi

# Install Docker Compose if not present
if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo apt install -y docker-compose-plugin
fi

# Clone repository if not already present
if [ ! -d "all-in-one" ]; then
    echo "Cloning Private Web3 SDK repository..."
    git clone https://github.com/Surealist123/all-in-one.git
    cd all-in-one
else
    echo "Repository already exists, updating..."
    cd all-in-one
    git pull
fi

# Make scripts executable
chmod +x validate-sdk.sh
chmod +x Containers/vpn/entrypoint.sh
chmod +x Containers/vpn/vpn-manager.sh
chmod +x Containers/web3-dev/entrypoint.sh
chmod +x Containers/web3-dev/web3-setup.sh

# Create data directories
echo "Creating data directories..."
mkdir -p $HOME/web3-sdk-data
mkdir -p $HOME/vpn-config

echo "===========================================" 
echo "Installation Complete!"
echo ""
echo "To start the Private Web3 SDK:"
echo "  docker compose up -d"
echo ""
echo "To validate the installation:"
echo "  ./validate-sdk.sh"
echo ""
echo "Access points:"
echo "  VPN Dashboard: https://localhost:8443"
echo "  Web3 Development: http://localhost:8545"
echo "  Nextcloud: https://localhost:443"
echo "===========================================" 