# Private Web3 Development SDK for Windows

A comprehensive, privacy-focused Web3 development environment with built-in VPN protection, designed specifically for Windows developers working on blockchain applications.

## Features

### 🛡️ Privacy & Security
- **Built-in VPN**: WireGuard-based VPN for secure, private development
- **DNS Privacy**: Cloudflare DoH (DNS over HTTPS) for enhanced privacy
- **Encrypted Traffic**: All development traffic routed through VPN
- **Isolated Network**: Containerized environment with network isolation

### 🚀 Web3 Development Tools
- **Hardhat**: Ethereum development environment
- **Truffle**: Smart contract development framework
- **Ganache**: Local blockchain for testing
- **Foundry**: Fast Ethereum application development toolkit
- **Web3.js & Ethers.js**: JavaScript libraries for blockchain interaction
- **OpenZeppelin**: Secure smart contract library

### 📁 Optional Cloud Storage
- **Nextcloud AIO**: Private cloud storage for your development files
- **Secure File Sharing**: Share development resources privately
- **Backup & Sync**: Automatic backup of your development workspace

## Quick Start

### Prerequisites
- Windows 10/11 with WSL2 enabled
- Docker Desktop for Windows
- 8GB+ RAM recommended
- 20GB+ free disk space

### Installation

1. **Clone the repository:**
   ```cmd
   git clone https://github.com/Surealist123/all-in-one.git
   cd all-in-one\windows-sdk
   ```

2. **Start the SDK:**
   ```cmd
   start-sdk.bat
   ```

3. **Wait for initialization** (first run may take 10-15 minutes)

4. **Access your development environment:**
   - VPN Dashboard: https://localhost:8443
   - Web3 Blockchain: http://localhost:8545
   - Nextcloud (optional): https://localhost:443

### Quick Test

```cmd
# Connect to the development container
docker exec -it web3-sdk-dev bash

# Test the local blockchain
npx hardhat console --network development

# In the Hardhat console:
> const accounts = await ethers.getSigners()
> console.log(accounts[0].address)
```

## VPN Configuration

### Server Setup
The VPN server runs automatically when you start the SDK. To configure clients:

1. Generate a client configuration:
   ```cmd
   docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh generate-client myclient
   ```

2. Copy the generated configuration to your VPN client
3. Connect using any WireGuard-compatible client

### Manual VPN Management
```cmd
# Check VPN status
docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh status

# Restart VPN
docker exec web3-sdk-vpn /opt/vpn-sdk/vpn-manager.sh restart
```

## Web3 Development

### Sample Smart Contract
A privacy-focused sample contract is included at `/workspace/contracts/sample-contract.sol`

### Development Workflow
1. Write smart contracts in `/workspace/contracts/`
2. Test with `npx hardhat test`
3. Deploy to local blockchain with `npx hardhat run scripts/deploy.js`
4. Interact with contracts using Web3.js or Ethers.js

### Available Commands
```cmd
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy contracts
npx hardhat run scripts/deploy.js

# Start Hardhat console
npx hardhat console

# Start local node
npx hardhat node
```

## Privacy Features

### Network Isolation
- All development traffic routed through VPN
- No direct internet access from development containers
- Encrypted communication between all components

### Data Protection
- Local data stored in encrypted Docker volumes
- Optional cloud storage with Nextcloud
- No telemetry or data collection

### Secure Development
- Pre-configured secure defaults
- Regular security updates
- Isolated development environment

## Troubleshooting

### Common Issues

**Docker not found:**
- Install Docker Desktop for Windows
- Ensure Docker is running

**VPN connection issues:**
- Check Windows Firewall settings
- Ensure UDP port 51820 is open
- Restart the VPN service

**Web3 connection problems:**
- Verify Ganache is running on port 8545
- Check network configuration in hardhat.config.js

### Getting Help
```cmd
# Check container status
docker-compose -f windows-compose.yaml ps

# View logs
docker-compose -f windows-compose.yaml logs

# Restart all services
stop-sdk.bat
start-sdk.bat
```

## Advanced Configuration

### Custom VPN Settings
Edit `Containers/vpn/wg0.conf` to customize VPN configuration

### Web3 Network Settings
Modify `Containers/web3-dev/hardhat.config.js` for custom blockchain settings

### Storage Location
Change data directory by editing `NEXTCLOUD_DATADIR` in `start-sdk.bat`

## Security Best Practices

1. **Regular Updates**: Keep the SDK updated with latest security patches
2. **Strong Passwords**: Use strong passwords for Nextcloud access
3. **VPN Keys**: Safely store and manage VPN private keys
4. **Network Security**: Use the SDK behind a firewall
5. **Data Backup**: Regularly backup your development workspace

## License

This project is licensed under the AGPL-3.0 License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review Docker logs for debugging

---

**Note**: This SDK is designed for development purposes. For production deployments, additional security hardening is recommended.