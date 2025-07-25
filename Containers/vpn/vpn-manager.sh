#!/bin/bash

# VPN Manager for Web3 SDK
# Manages WireGuard VPN connection for privacy

VPN_CONFIG="/etc/wireguard/wg0.conf"
VPN_INTERFACE="wg0"

start_vpn() {
    echo "Starting VPN interface $VPN_INTERFACE..."
    if wg-quick up "$VPN_INTERFACE"; then
        echo "VPN started successfully"
        return 0
    else
        echo "Failed to start VPN"
        return 1
    fi
}

stop_vpn() {
    echo "Stopping VPN interface $VPN_INTERFACE..."
    if wg-quick down "$VPN_INTERFACE"; then
        echo "VPN stopped successfully"
        return 0
    else
        echo "Failed to stop VPN"
        return 1
    fi
}

status_vpn() {
    if wg show "$VPN_INTERFACE" > /dev/null 2>&1; then
        echo "VPN is running"
        wg show "$VPN_INTERFACE"
        return 0
    else
        echo "VPN is not running"
        return 1
    fi
}

generate_client_config() {
    local client_name="$1"
    if [ -z "$client_name" ]; then
        echo "Usage: generate_client_config <client_name>"
        return 1
    fi
    
    echo "Generating client configuration for $client_name..."
    # Generate client keys
    client_private_key=$(wg genkey)
    client_public_key=$(echo "$client_private_key" | wg pubkey)
    
    # Output client configuration
    cat > "/tmp/${client_name}-wg.conf" << EOF
[Interface]
PrivateKey = $client_private_key
Address = 10.0.0.2/24
DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = $(cat /etc/wireguard/publickey)
Endpoint = \${SERVER_IP}:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
    
    echo "Client configuration saved to /tmp/${client_name}-wg.conf"
    echo "Client public key: $client_public_key"
}

case "$1" in
    start)
        start_vpn
        ;;
    stop)
        stop_vpn
        ;;
    status)
        status_vpn
        ;;
    restart)
        stop_vpn
        sleep 2
        start_vpn
        ;;
    generate-client)
        generate_client_config "$2"
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|generate-client <name>}"
        exit 1
        ;;
esac