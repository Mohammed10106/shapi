#!/bin/bash
# Show current date with optional format

# Read JSON input from stdin
input=$(cat -)
format=$(echo "$input" | jq -r '.parameters.format // "%Y-%m-%d %H:%M:%S"' 2>/dev/null || echo "%Y-%m-%d %H:%M:%S")

# Show current date with specified format
date "+$format"
