#!/bin/bash

# Get current timestamp for filename
timestamp=$(date +%Y%m%d_%H%M%S)

# Get current minute for even/odd check
minute=$(date +%M)
minute_num=$((10#$minute))

# Base directory for logs (current directory by default)
log_dir="."

if (( minute_num % 2 == 0 )); then
    # Even minute: success
    log_file="${log_dir}/success_${timestamp}.log"
    echo "Success at $(date)" >> "$log_file"
    exit 0
else
    # Odd minute: error
    log_file="${log_dir}/error_${timestamp}.log"
    echo "Error: Failed at $(date)" >> "$log_file"
    exit 1
fi
