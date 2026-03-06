#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ulimit -n 51200
echo "Starting Shadowsocks Client..."
echo "SOCKS5 proxy will be available at 127.0.0.1:1080"
echo "Press Ctrl+C to stop."
ss-local -c "$DIR/client_config.json"
