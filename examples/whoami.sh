#!/bin/bash
# Simple whoami command with additional user information
echo "Username: $(whoami)"
echo "User ID: $(id -u)"
echo "Groups: $(groups)"
