#!/data/data/com.termux/files/usr/bin/bash

PROJECT_ROOT=~/termux-alcupiere
SESSION_ID=$(date +"%Y%m%dT%H%M%S")
LOG_FILE="$PROJECT_ROOT/logs/watch_$SESSION_ID.log"

echo "[+] Starting watch session: $SESSION_ID" | tee -a "$LOG_FILE"

inotifywait -m -r -e create -e delete -e modify --format '%T %e %w%f' --timefmt '%Y-%m-%dT%H:%M:%S' "$PROJECT_ROOT" \
  | while read -r line; do
      echo "[FS] $line" >> "$LOG_FILE"
    done &
WATCH_PID=$!

trap "echo '[!] Stopping watch session: $SESSION_ID' >> $LOG_FILE; kill $WATCH_PID" EXIT

tail -F "$PROJECT_ROOT/logs/"*.log 2>/dev/null | while read -r line; do
  echo "[LOG] $(date -Iseconds) $line" >> "$LOG_FILE"
done
