#!/usr/bin/env bash
# run this to make the script executable -
# sysuser@ubuntuprod:~/git/ldk/linux/scripts (master -> origin/master)$ chmod +x kate_insert_date_time_iso-8601.sh
printf "%s" "$(date '+%Y-%m-%dT%H:%M:%S')"
