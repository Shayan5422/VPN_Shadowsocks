#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default values
DEFAULT_PORT=31763
DEFAULT_METHOD="chacha20-ietf-poly1305"
DEFAULT_PASSWORD=$(openssl rand -base64 16 2>/dev/null || head -c 16 /dev/urandom | base64)

echo "========================================"
echo "   Shadowsocks Setup"
echo "========================================"

read -p "Port [$DEFAULT_PORT]: " PORT
PORT=${PORT:-$DEFAULT_PORT}

read -p "Password [$DEFAULT_PASSWORD]: " PASSWORD
PASSWORD=${PASSWORD:-$DEFAULT_PASSWORD}

read -p "Encryption method [$DEFAULT_METHOD]: " METHOD
METHOD=${METHOD:-$DEFAULT_METHOD}

echo ""
read -p "Run as (s)erver or (c)lient? [s]: " MODE
MODE=${MODE:-s}

if [ "$MODE" = "c" ]; then
    read -p "Server IP: " SERVER_IP
    if [ -z "$SERVER_IP" ]; then
        echo "Server IP is required for client mode."
        exit 1
    fi

    cat > "$DIR/client_config.json" <<EOF
{
    "server": "$SERVER_IP",
    "server_port": $PORT,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "$PASSWORD",
    "method": "$METHOD",
    "timeout": 600,
    "mode": "tcp_and_udp",
    "no_delay": true,
    "fast_open": true
}
EOF
    echo "Client config saved to client_config.json"
    echo "Run: bash start_client.sh"

else
    cat > "$DIR/config.json" <<EOF
{
    "server": "0.0.0.0",
    "server_port": $PORT,
    "password": "$PASSWORD",
    "method": "$METHOD",
    "timeout": 600,
    "mode": "tcp_and_udp",
    "no_delay": true,
    "fast_open": true
}
EOF
    echo "Server config saved to config.json"
    echo "Run: bash start_server.sh"
fi

echo ""
echo "Done!"
