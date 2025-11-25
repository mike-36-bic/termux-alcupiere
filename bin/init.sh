#!/data/data/com.termux/files/usr/bin/bash

PROJECT_ROOT="$HOME/termux-alcupiere"
LOG_FILE="$PROJECT_ROOT/logs/init.log"
ENV_FILE="$PROJECT_ROOT/env/github.env"

mkdir -p "$PROJECT_ROOT/logs"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Acupieré Initialization ==="
echo "Timestamp: $(date)"
echo ""

echo "[*] Checking scaffold structure..."
REQUIRED_DIRS=(bin config env logs projects archive tags prompts)
MISSING=()

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$PROJECT_ROOT/$dir" ]; then
    MISSING+=("$dir")
  fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
  echo "[✓] All required directories exist."
else
  echo "[!] Missing directories: ${MISSING[*]}"
  echo "[+] Creating missing directories..."
  for dir in "${MISSING[@]}"; do
    mkdir -p "$PROJECT_ROOT/$dir"
    echo "  - Created: $dir"
  done
fi

# ===  Check for Git initialization ===
cd "$PROJECT_ROOT"
if [ -d .git ]; then
  echo "[✓] Git repository already initialized."
else
  echo "[!] No Git repo found. Initializing..."
  git init
fi

# ===  Check for Git remote ===
if git remote | grep -q origin; then
  echo "[✓] Git remote 'origin' already set."
else
  echo "[!] Git remote not set."
  read -p "Enter your GitHub username: " GH_USER
  read -p "Enter your GitHub repo name (e.g., termux-alcupiere): " GH_REPO
  GH_URL="git@github.com:$GH_USER/$GH_REPO.git"

  echo "[+] Adding remote origin: $GH_URL"
  git remote add origin "$GH_URL"

  mkdir -p "$PROJECT_ROOT/env"
  cat <<EOF > "$ENV_FILE"
export GH_USER="$GH_USER"
export GH_REPO="$GH_REPO"
export GH_URL="$GH_URL"
EOF
  echo "[✓] GitHub environment saved to env/github.env"
fi

# ===  Check for Git identity ===
GIT_NAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
  echo "[!] Git global identity not set."
  read -p "Enter your Git user.name: " NAME
  read -p "Enter your Git user.email: " EMAIL
  git config --global user.name "$NAME"
  git config --global user.email "$EMAIL"
  echo "[✓] Git global identity configured."
else
  echo "[✓] Git global identity already set: $GIT_NAME <$GIT_EMAIL>"
fi

# ===  SSH Key Check ===
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "[!] No SSH key found. Running ssh.sh..."
  bash "$PROJECT_ROOT/bin/ssh.sh"
else
  echo "[✓] SSH key already exists."
fi

echo ""
echo "[✓] Initialization complete. Log saved to $LOG_FILE"
