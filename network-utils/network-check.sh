#!/bin/sh
# Simple network connectivity checker
if [ -z "$1" ]; then
    echo "Usage: network-check <hostname>"
    echo "A simple network connectivity checker"
    exit 1
fi

echo "Checking connectivity to $1..."
ping -c 1 -W 2 "$1" >/dev/null 2>&1 && echo "✓ $1 is reachable" || echo "✗ $1 is unreachable"
