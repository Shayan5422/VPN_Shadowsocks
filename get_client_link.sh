#!/usr/bin/env python3
import json
import base64
import urllib.request
import os
import sys

def get_public_ip():
    try:
        # Use api.ipify.org to ensure we get an IPv4 address
        return urllib.request.urlopen('https://api.ipify.org', timeout=5).read().decode('utf8')
    except Exception as e:
        print(f"Warning: Could not automatically detect public IP ({e}).")
        return "YOUR_PUBLIC_IP"

def generate_link():
    # Determine the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(script_dir, 'config.json')

    if not os.path.exists(config_path):
        print(f"Error: config.json not found at {config_path}")
        sys.exit(1)

    with open(config_path, 'r') as f:
        config = json.load(f)

    # Basic configuration validation
    required_keys = ['method', 'password', 'server_port']
    for key in required_keys:
        if key not in config:
            print(f"Error: Missing '{key}' in config.json")
            sys.exit(1)

    method = config['method']
    password = config['password']
    port = config['server_port']
    
    print("Detecting Public IP...")
    external_ip = get_public_ip()

    # Format: method:password@hostname:port
    user_info = f"{method}:{password}"
    user_info_b64 = base64.b64encode(user_info.encode()).decode()
    
    # Handle plugin
    plugin_part = ""
    if 'plugin' in config:
        plugin_name = config['plugin']
        # Map server plugin to client plugin name if needed
        if plugin_name == 'obfs-server':
            plugin_name = 'obfs-local'
        
        opts = config.get('plugin_opts', '')
        # Prepare plugin string: name;opts
        plugin_str = f"{plugin_name};{opts}"
        # URL encode the plugin string
        import urllib.parse
        plugin_part = f"/?plugin={urllib.parse.quote(plugin_str)}"

    ss_uri = f"ss://{user_info_b64}@{external_ip}:{port}{plugin_part}#{external_ip}:{port}"

    print("\n" + "="*40)
    print("   VPN CONNECTION DETAILS")
    print("="*40)
    print(f"Server IP : {external_ip}")
    print(f"Port      : {port}")
    print(f"Method    : {method}")
    print(f"Password  : {password}")
    print("-" * 40)
    print("DIRECT LINK (Copy this to your client):")
    print("\n" + ss_uri + "\n")
    print("="*40)
    print("NOTE: Ensure port forwarding is configured on your router!")
    print(f"Map external port {port} to this machine's local IP on port {port}.")
    print("="*40 + "\n")

if __name__ == "__main__":
    generate_link()
