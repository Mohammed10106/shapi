#!/bin/bash
# Show current user information

# Read JSON input from stdin (unused in this script, but kept for consistency)
cat - > /dev/null

# Show user information
echo "Username: $(whoami)"
echo "User ID: $(id -u)"
echo "Groups: $(groups)"
