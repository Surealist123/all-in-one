# Private Web3 Development SDK - Developer Guide

## Overview

This enhanced Nextcloud AIO distribution includes a complete Web3 development environment with built-in VPN protection, specifically designed for privacy-focused blockchain application development.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Host System                         │
│  ┌─────────────────────────────────────────────────────┐ │
│  │                Docker Network                       │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │ │
│  │  │     VPN     │  │   Web3 Dev  │  │  Nextcloud  │  │ │
│  │  │ (WireGuard) │◄─┤   Tools     │◄─┤     AIO     │  │ │
│  │  │             │  │             │  │             │  │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │ │
│  │         │                │                │         │ │
│  └─────────┼────────────────┼────────────────┼─────────┘ │
│            │                │                │           │
│     ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐    │
│     │   Port      │  │   Port      │  │   Port      │    │
│     │   51820     │  │   8545      │  │   8443      │    │
│     │  (VPN)      │  │ (Blockchain)│  │ (Nextcloud) │    │
│     └─────────────┘  └─────────────┘  └─────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. VPN Container (Privacy Layer)
- **Technology**: WireGuard VPN
- **Purpose**: Encrypt all development traffic
- **Features**:
  - Automatic key generation
  - DNS over HTTPS (DoH)
  - Kill switch protection
  - Client configuration generation

### 2. Web3 Development Container
- **Base**: Node.js 20 Alpine
- **Tools Included**:
  - Hardhat (Ethereum development environment)
  - Truffle (Smart contract framework)
  - Ganache (Local blockchain)
  - Foundry (Fast development toolkit)
  - Web3.js & Ethers.js (JavaScript libraries)
  - OpenZeppelin (Secure contract library)
- **Features**:
  - Pre-configured development environment
  - Sample smart contracts
  - Automated blockchain setup
  - Hot reload development

### 3. Nextcloud AIO (Optional Storage)
- **Purpose**: Secure file storage and collaboration
- **Integration**: Stores development files and project assets
- **Features**:
  - Encrypted file storage
  - Version control integration
  - Secure sharing
  - Backup functionality

## Getting Started

### Prerequisites
- Docker Desktop (Windows/macOS) or Docker Engine (Linux)
- 8GB+ RAM recommended
- 20GB+ free disk space
- Internet connection for initial setup

### Quick Start

#### Windows (Recommended)
```cmd
cd windows-sdk
start-sdk.bat
```

#### Linux/macOS
```bash
docker compose up -d
```

#### PowerShell (Windows)
```powershell
cd windows-sdk
./start-sdk.ps1 -Action start
```

### First Time Setup

1. **Start the SDK** using one of the methods above
2. **Wait for initialization** (first run may take 10-15 minutes)
3. **Access the VPN dashboard** at https://localhost:8443
4. **Connect to the development environment**:
   ```bash
   docker exec -it nextcloud-aio-web3-dev bash
   # or for Windows SDK:
   docker exec -it web3-sdk-dev bash
   ```

## Development Workflow

### 1. Smart Contract Development

```bash
# Enter development container
docker exec -it web3-sdk-dev bash

# Navigate to workspace
cd /workspace

# Create a new contract
nano contracts/MyContract.sol

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to local blockchain
npx hardhat run scripts/deploy.js --network development
```

### 2. Testing and Debugging

```bash
# Start Hardhat console
npx hardhat console --network development

# In console - interact with contracts
> const MyContract = await ethers.getContractFactory("MyContract")
> const contract = await MyContract.deploy()
> await contract.deployed()
```

### 3. Frontend Development

```bash
# Install frontend dependencies
npm install react web3 ethers

# Create React app with Web3 integration
npx create-react-app my-dapp
cd my-dapp
npm install web3
```

## Privacy Features

### VPN Protection
- All development traffic routed through encrypted VPN
- DNS queries protected with DNS over HTTPS
- No IP leakage protection
- Automatic reconnection

### Network Isolation
- Containers communicate through private Docker network
- No direct internet access from development containers
- Firewall rules automatically configured

### Data Protection
- Local data encrypted in Docker volumes
- Optional cloud storage with Nextcloud
- No telemetry or tracking
- Secure key management

## Configuration

### Environment Variables

Create `.env` file from `.env.example`:
```bash
cp .env.example .env
# Edit .env with your preferences
```

Key settings:
- `VPN_SERVER_IP`: External IP for VPN server
- `WEB3_NETWORK`: Blockchain network configuration
- `NEXTCLOUD_DATADIR`: Data storage location
- `ENABLE_VPN_KILLSWITCH`: Block traffic if VPN fails

### VPN Client Setup

Generate client configuration:
```bash
docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh generate-client myclient
```

Use generated config with any WireGuard client.

### Custom Networks

Edit `Containers/web3-dev/hardhat.config.js`:
```javascript
networks: {
  development: {
    url: "http://localhost:8545",
    chainId: 1337
  },
  testnet: {
    url: "https://rpc.testnet.example.com",
    accounts: ["0x..."]
  }
}
```

## Advanced Usage

### Custom Smart Contract Libraries

Add libraries to package.json:
```json
{
  "dependencies": {
    "@chainlink/contracts": "^0.6.1",
    "@uniswap/v3-core": "^1.0.1"
  }
}
```

### Integration Testing

```bash
# Run comprehensive tests
npx hardhat test test/**/*.js

# Gas usage analysis
npx hardhat test --gas

# Code coverage
npx hardhat coverage
```

### Production Deployment

```bash
# Deploy to testnet
npx hardhat run scripts/deploy.js --network sepolia

# Verify contract on Etherscan
npx hardhat verify --network sepolia DEPLOYED_CONTRACT_ADDRESS
```

## Troubleshooting

### Common Issues

#### VPN Connection Problems
```bash
# Check VPN status
docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh status

# Restart VPN
docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh restart

# Check logs
docker logs web3-sdk-vpn
```

#### Blockchain Connection Issues
```bash
# Check Ganache status
docker logs web3-sdk-dev

# Restart blockchain
docker restart web3-sdk-dev

# Test connection
curl http://localhost:8545
```

#### Container Startup Problems
```bash
# Check all container status
docker compose ps

# View logs
docker compose logs

# Restart all services
docker compose restart
```

### Performance Optimization

#### Memory Settings
```yaml
# In docker-compose.yaml
services:
  web3-dev:
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 2G
```

#### Storage Optimization
```bash
# Clean up unused containers
docker system prune

# Remove unused volumes
docker volume prune

# Monitor disk usage
docker system df
```

## Security Best Practices

### Development Security
1. **Never commit private keys** to version control
2. **Use environment variables** for sensitive data
3. **Keep containers updated** regularly
4. **Use strong passwords** for Nextcloud access
5. **Backup VPN keys** securely

### Network Security
1. **Use firewall** to block unnecessary ports
2. **Keep VPN enabled** during development
3. **Regularly rotate VPN keys**
4. **Monitor container logs** for suspicious activity

### Data Security
1. **Encrypt sensitive files** in Nextcloud
2. **Use secure backup solutions**
3. **Limit file sharing** to necessary parties
4. **Regular security audits**

## API Reference

### VPN Manager Commands
```bash
# Start VPN
/opt/vpn-sdk/vpn-manager.sh start

# Stop VPN
/opt/vpn-sdk/vpn-manager.sh stop

# Check status
/opt/vpn-sdk/vpn-manager.sh status

# Generate client config
/opt/vpn-sdk/vpn-manager.sh generate-client <name>
```

### Development Commands
```bash
# Hardhat commands
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.js
npx hardhat console

# Truffle commands
truffle compile
truffle test
truffle migrate
truffle console

# Foundry commands
forge build
forge test
forge create
```

## Contributing

### Adding New Features
1. Fork the repository
2. Create feature branch
3. Add comprehensive tests
4. Update documentation
5. Submit pull request

### Reporting Issues
- Use GitHub issues
- Include container logs
- Describe reproduction steps
- Specify environment details

## License

This project is licensed under AGPL-3.0 - see LICENSE file for details.

## Support

- GitHub Issues: Report bugs and feature requests
- Documentation: Check this guide and README files
- Community: Join discussions in GitHub Discussions

---

**Remember**: This SDK is for development purposes. Production deployments require additional security hardening and configuration.