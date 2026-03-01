#!/bin/bash
# Directory listing utility

dir="${1:-.}"
echo "Contents of $dir:"
ls -lah "$dir"
