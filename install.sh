#!/bin/bash
set -e

OS="$(uname -s)"

echo "Installing shadowsocks-libev..."

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
    brew install shadowsocks-libev

elif [ "$OS" = "Linux" ]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y shadowsocks-libev
    elif command -v yum &> /dev/null; then
        sudo yum install -y epel-release
        sudo yum install -y shadowsocks-libev
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y shadowsocks-libev
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm shadowsocks-libev
    else
        echo "Unsupported Linux distro. Install shadowsocks-libev manually."
        exit 1
    fi
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "Installation complete."
