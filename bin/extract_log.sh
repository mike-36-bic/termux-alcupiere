#!/data/data/com.termux/files/usr/bin/bash

LOG_DIR=~/termux-alcupiere/logs
FILTER="cat"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --timestamp) TS="$2"; shift ;;
    --github) FILTER="$FILTER | grep '\[GITHUB\]'" ;;
    --error) FILTER="$FILTER | grep '\[ERROR\]'" ;;
  esac
  shift
done

for file in "$LOG_DIR"/watch_*.log; do
  if [[ -n "$TS" ]]; then
    grep "$TS" "$file" | eval "$FILTER"
  else
    eval "$FILTER < \"$file\""
  fi
done
