#!/bin/bash
# Simple ps command with optional pattern matching
PATTERN="${1:-""}"
ps aux | grep -i "$PATTERN" | grep -v grep
