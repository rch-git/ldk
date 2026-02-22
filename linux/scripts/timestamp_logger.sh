#!/bin/bash

# Usage: ./timestamp_logger.sh /path/to/your/file.txt

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "File $FILE does not exist. Creating it."
    touch "$FILE"
fi

echo "Starting infinite timestamp appending to $FILE. Press Ctrl+C to stop."
echo "" >> "$FILE"
while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$FILE"
    sleep 3  # Change this value to adjust interval (e.g., sleep 60 for every minute)
done
