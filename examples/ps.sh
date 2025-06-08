#!/bin/bash
# Simple ps command with optional JSON input

# Read JSON input from stdin
input=$(cat -)
pattern=$(echo "$input" | jq -r '.parameters.pattern // ""' 2>/dev/null || echo "")

# List processes with optional filtering
ps aux | grep -i "$pattern" | grep -v grep
