#!/bin/bash
# Simple ls command with optional directory parameter
DIR="${1:-.}"
ls -la "$DIR"
