#!/data/data/com.termux/files/usr/bin/bash

GITHUB_USER="$1"
KEY_COMMENT="${GITHUB_USER}termux-alcupiere"
KEY_PATH="$HOME/.ssh/id_rsa"

pkg install -y openssh

if [ ! -f "$KEY_PATH" ]; then
  echo "[+] Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "$KEY_COMMENT" -f "$KEY_PATH" -N ""
else
  echo "[*] SSH key already exists at $KEY_PATH"
fi

eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

echo "[+] Public key (copy this to GitHub SSH settings):"
cat "${KEY_PATH}.pub"

ssh-keyscan github.com >> ~/.ssh/known_hosts

echo "[✓] SSH setup complete. Add the above key to GitHub: https://github.com/settings/keys"
