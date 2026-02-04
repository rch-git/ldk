
#!/bin/bash
# Usage ./check_minute.sh > success.log 2> error.log
# Usage ./check_minute.sh >& all-output.log

minute=$(date +%M)          # Get current minute (00-59)
minute_num=$((10#$minute))  # Convert to integer (handles leading zero)

if (( minute_num % 2 == 0 )); then
    # Even minute: success
    echo "Success at $(date)" >&1
    exit 0
else
    # Odd minute: error
    echo "Error: Failed at $(date)" >&2
    exit 1
fi
