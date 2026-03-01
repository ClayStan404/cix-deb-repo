#!/bin/sh
if [ -z "$1" ]; then
    echo "Usage: word-count <file>"
    echo "Count words in a text file"
    exit 1
fi

wc -w "$1" 2>/dev/null || echo "Error: cannot read file"
