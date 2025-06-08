#!/bin/bash
# Memory usage with human-readable output

# Read JSON input from stdin (unused in this script, but kept for consistency)
cat - > /dev/null

# Show memory usage
free -h
