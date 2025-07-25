FROM alpine:3.20

# Install WireGuard and necessary tools for VPN functionality
RUN apk update && apk add --no-cache \
    wireguard-tools \
    iptables \
    iproute2 \
    bash \
    curl \
    openssl \
    dnsmasq \
    ca-certificates \
    supervisor \
    && rm -rf /var/cache/apk/*

# Create VPN directories
RUN mkdir -p /etc/wireguard /var/log/supervisor /opt/vpn-sdk

# Copy configuration files
COPY wg0.conf /etc/wireguard/
COPY entrypoint.sh /opt/vpn-sdk/
COPY supervisord.conf /etc/supervisor/conf.d/
COPY vpn-manager.sh /opt/vpn-sdk/

# Make scripts executable
RUN chmod +x /opt/vpn-sdk/entrypoint.sh /opt/vpn-sdk/vpn-manager.sh

# Expose ports for VPN
EXPOSE 51820/udp 53/udp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /opt/vpn-sdk/vpn-manager.sh status || exit 1

ENTRYPOINT ["/opt/vpn-sdk/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]