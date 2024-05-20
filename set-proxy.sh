#!/bin/bash

# Set proxy variables
PROXY_SERVER="http://your-proxy-server:port"
NO_PROXY="localhost,127.0.0.1"

# Export proxy variables
echo "Setting proxy variables..."
echo "export HTTP_PROXY=$PROXY_SERVER" >> ~/.bashrc
echo "export HTTPS_PROXY=$PROXY_SERVER" >> ~/.bashrc
echo "export NO_PROXY=$NO_PROXY" >> ~/.bashrc

# Source the configuration
source ~/.bashrc

# Create systemd directories for Podman
mkdir -p ~/.config/systemd/user/podman.service.d/

# Create systemd service override file for Podman
echo "Configuring Podman systemd service with proxy settings..."
cat <<EOF > ~/.config/systemd/user/podman.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=$PROXY_SERVER"
Environment="HTTPS_PROXY=$PROXY_SERVER"
Environment="NO_PROXY=$NO_PROXY"
EOF

# Reload and restart systemd services
echo "Reloading systemd manager configuration and restarting Podman service..."
systemctl --user daemon-reload
systemctl --user restart podman.service

# Verify the configuration
echo "Proxy configuration for Podman completed. Verifying settings..."
podman info | grep -i proxy
