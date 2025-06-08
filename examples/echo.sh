#!/bin/bash
# Echo back input text with optional prefix and suffix

# Read JSON input from stdin
input=$(cat -)
text=$(echo "$input" | jq -r '.parameters.text // ""' 2>/dev/null || echo "")
prefix=$(echo "$input" | jq -r '.parameters.prefix // ""' 2>/dev/null || echo "")
suffix=$(echo "$input" | jq -r '.parameters.suffix // ""' 2>/dev/null || echo "")

# If no text parameter, use command line arguments
if [ -z "$text" ] && [ $# -gt 0 ]; then
    text="$*"
fi

# Output the result
echo "${prefix}${text}${suffix}"
