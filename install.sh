#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

echo "Installing shadowsocks-libev..."
brew install shadowsocks-libev

echo "Installation complete."
