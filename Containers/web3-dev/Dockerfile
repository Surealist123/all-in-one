FROM node:20-alpine

# Install system dependencies for Web3 development
RUN apk add --no-cache \
    git \
    python3 \
    py3-pip \
    build-base \
    linux-headers \
    libc6-compat \
    curl \
    bash \
    supervisor \
    && rm -rf /var/cache/apk/*

# Install global Web3 development tools
RUN npm install -g \
    @truffle/truffle \
    @ganache/cli \
    hardhat \
    @foundry-rs/foundry \
    web3 \
    ethers \
    @openzeppelin/contracts \
    solhint \
    prettier \
    prettier-plugin-solidity

# Install Python Web3 tools
RUN pip3 install \
    web3 \
    brownie-eth \
    eth-ape

# Create workspace directory
RUN mkdir -p /workspace /var/log/supervisor
WORKDIR /workspace

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/
COPY entrypoint.sh /usr/local/bin/
COPY web3-setup.sh /usr/local/bin/

# Make scripts executable
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/web3-setup.sh

# Create sample Web3 project structure
RUN mkdir -p /workspace/contracts /workspace/scripts /workspace/test /workspace/artifacts

# Copy sample files
COPY sample-contract.sol /workspace/contracts/
COPY hardhat.config.js /workspace/
COPY package.json /workspace/

# Install project dependencies
RUN npm install

# Expose ports
EXPOSE 8545 8546 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8545/ || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]