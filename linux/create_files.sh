#!/bin/bash

# Base directory
base="temp_logs"

# Create the directory structure
mkdir -p "${base}/error_logs/warning_logs"
mkdir -p "${base}/debug_logs"
mkdir -p "${base}/info_logs/notice_logs"
mkdir -p "${base}/info_logs/notice_logs/swp"

# Function to create 10 log files in a given directory with prefix
create_logs() {
    local dir="$1"
    local prefix="$2"
   
    # Get current Unix timestamp
    local start_ts=$(date +%s)
   
    for i in {0..9}; do
        local ts=$((start_ts + i)) # Increment by 1 second for uniqueness
        touch "${dir}/${prefix}_${ts}.log"
    done
}

# Create files
create_logs "${base}/error_logs" "error"
create_logs "${base}/error_logs/warning_logs" "warning"
create_logs "${base}/debug_logs" "debug"
create_logs "${base}/info_logs" "info"
create_logs "${base}/info_logs/notice_logs" "notice"

# Paragraph to repeat
paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum non aliquet massa. Suspendisse cursus et felis eu semper. Nullam interdum tellus leo, eget congue orci consectetur id. Nulla dui sapien, lacinia ac tellus id, ultrices placerat turpis. Ut tincidunt, risus id gravida semper, arcu massa eleifend turpis, at vulputate mauris enim et nisl. Aenean at diam quis purus vehicula accumsan. Fusce condimentum ex eget turpis gravida suscipit. Suspendisse condimentum lectus nisl. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas eu est non ante lacinia venenatis. In vel dui lectus. Proin eu nunc eu eros sagittis laoreet eu eu nisi. Phasellus id lobortis lectus. Proin volutpat id lacus in feugiat. Pellentesque et risus vel orci consectetur rhoncus. Integer vehicula rutrum eros, in iaculis enim pulvinar sit amet."

# Line to write (paragraph + newline)
line="${paragraph}"$'\n'

# Function to create 10 swp files, each with 40000 lines of the paragraph
create_swp() {
    local dir="$1"
    local prefix="$2"

    # Get current Unix timestamp
    local start_ts=$(date +%s)

    for i in {0..9}; do
        local ts=$((start_ts + i))  # Increment by 1 second for uniqueness
        local file="${dir}/${prefix}_${ts}.swp"

        # Fastest way: build the entire content once and write in one go
        printf '%s' "${line}" | awk '{for(i=0;i<40000;i++) print "%s",$0}' > "$file"
    done
}

create_swp "${base}/info_logs/notice_logs/swp" "swp"