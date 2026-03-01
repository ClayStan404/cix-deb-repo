#!/bin/bash
# Simple file info utility

if [ $# -eq 0 ]; then
    echo "Usage: file-info <file>"
    exit 1
fi

for file in "$@"; do
    if [ -e "$file" ]; then
        echo "=== $file ==="
        echo "Size: $(stat -c%s "$file") bytes"
        echo "Type: $(file -b "$file")"
        echo "Permissions: $(stat -c%A "$file")"
    else
        echo "Error: $file does not exist"
    fi
done
