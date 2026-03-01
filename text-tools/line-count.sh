#!/bin/sh
if [ -z "$1" ]; then
    echo "Usage: line-count <file>"
    echo "Count lines in a text file"
    exit 1
fi

wc -l "$1" 2>/dev/null || echo "Error: cannot read file"
