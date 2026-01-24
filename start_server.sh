#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ulimit -n 51200
echo "Starting Shadowsocks Server..."
echo "Press Ctrl+C to stop."
ss-server -c "$DIR/config.json"
