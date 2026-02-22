#! /bin/bash

# User will enter a filename and the program will search the entire system for that
# filename and either return the path to the file or a file not found message

echo -n 'Enter filename: '
read -r filename
echo "Entered filename: $filename"

matches=$(find / -type f -name "$filename" -print 2>/dev/null)

if [ -n "$matches" ]; then
  echo "Found:"
  printf '%s\n' "$matches"
else
  echo "File not found."
fi