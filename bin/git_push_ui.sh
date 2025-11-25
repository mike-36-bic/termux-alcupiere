#!/data/data/com.termux/files/usr/bin/bash

source ~/termux-alcupiere/env/github.env
LOG_FILE=~/termux-alcupiere/logs/git_push.log
COMMIT_MSG=$(whiptail --title "Git Commit" --inputbox "Enter your commit message:" 10 60 3>&1 1>&2 2>&3)

whiptail --yesno "Push to upstream branch 'main'?" 8 50
if [ $? -eq 0 ]; then
  {
echo "[GIT] $(date -Iseconds) Adding files..." >> "$LOG_FILE"
git add . >> "$LOG_FILE" 2>&1

echo "[GIT] $(date -Iseconds) Committing: $COMMIT_MSG" >> "$LOG_FILE"
git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1

echo "[GITHUB] $(date -Iseconds) Pushing to origin/main..." >> "$LOG_FILE"
git push -u origin main >> "$LOG_FILE" 2>&1

echo "[✓] $(date -Iseconds) Push complete." >> "$LOG_FILE"    git branch -M main
    git push -u origin main

    echo "[✓] Push complete at $(date)"
  } >> "$LOG_FILE" 2>&1
  whiptail --msgbox "Push successful. Log saved to $LOG_FILE" 10 50
else
  echo "[!] Push canceled by user at $(date)" >> "$LOG_FILE"
  whiptail --msgbox "Push canceled." 8 40
fi
