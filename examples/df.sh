#!/bin/bash
# Disk usage with human-readable output

# Read JSON input from stdin (unused in this script, but kept for consistency)
cat - > /dev/null

# Show disk usage
df -h
