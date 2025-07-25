#!/bin/bash
set -e

echo "Starting VPN container for private Web3 development SDK..."

# Generate WireGuard keys if they don't exist
if [ ! -f /etc/wireguard/privatekey ]; then
    echo "Generating WireGuard keys..."
    wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
    chmod 600 /etc/wireguard/privatekey
fi

# Set up iptables rules for VPN
echo "Setting up iptables rules..."
iptables -A INPUT -p udp --dport 51820 -j ACCEPT
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A FORWARD -o wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configure DNS for privacy
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf

echo "VPN container initialized successfully"

# Execute the command
exec "$@"