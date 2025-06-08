#!/bin/bash
# Simple ls command with optional JSON input

# Read JSON input from stdin
input=$(cat -)
directory=$(echo "$input" | jq -r '.parameters.directory // "."' 2>/dev/null || echo ".")

# List directory contents with details
ls -la "$directory"
