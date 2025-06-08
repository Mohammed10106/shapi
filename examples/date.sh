#!/bin/bash
# Simple date command with formatting
# Optional format parameter (default: "%Y-%m-%d %H:%M:%S")
FORMAT="${1:-"%Y-%m-%d %H:%M:%S"}"
date "+$FORMAT"
