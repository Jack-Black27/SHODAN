#!/bin/bash

# === Universal Git Setup Script ===
# Works on Desktop Linux/macOS + Termux (Android)

REPO_URL="git@github.com:Jack-Black27/SHODAN.git"
BRANCH="main"

echo "🔧 Starting Git setup..."

# Detect Termux vs Desktop
if [[ "$PREFIX" == *"com.termux"* ]]; then
    echo "📱 Termux environment detected"
    pkg update -y && pkg upgrade -y
    pkg install -y git openssh
else
    echo "💻 Desktop/Linux/macOS environment detected"
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y git openssh-client
    elif command -v brew >/dev/null 2>&1; then
        brew install git openssh
    fi
fi

# Configure Git identity
read -p "👉 Enter your Git username: " GIT_USER
git config --global user.name "$GIT_USER"

read -p "👉 Enter your Git email: " GIT_EMAIL
git config --global user.email "$GIT_EMAIL"

echo "✅ Git identity set: $GIT_USER <$GIT_EMAIL>"

# Generate SSH key if not present
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "🔑 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/id_ed25519 -N ""
    echo "⚠️ Copy this SSH key to GitHub:"
    cat ~/.ssh/id_ed25519.pub
    echo "➡️ Go to https://github.com/settings/keys and add it."
    read -p "Press Enter once added to GitHub..."
fi

# Test GitHub connection
ssh -T git@github.com

# Clone repo if not present
if [ ! -d "SHODAN" ]; then
    echo "📂 Cloning repo..."
    git clone -b $BRANCH $REPO_URL
else
    echo "📂 Repo already exists. Skipping clone."
fi

echo "🎉 Setup complete. You can now use:"
echo "  cd SHODAN"
echo "  git pull origin $BRANCH"
echo "  git add . && git commit -m 'your message' && git push origin $BRANCH"# -------------------------
# Mobile Assets
# -------------------------
/android/app/build/
/ios/build/
/ios/Pods/

# -------------------------
# Security
# -------------------------
.env
*.key
*.pem
*.crt
secrets.json
EOF
echo ">>> .gitignore created."

# --- Create BRANCHING.md ---
cat > BRANCHING.md <<'EOF'
# Branch & Tag Strategy

## Branches
- **main** → Stable releases only. Always rollback-safe.  
- **dev** → Integration branch for upcoming milestones (beta features).  
- **feature/*** → Individual module branches (e.g., `feature/grid-ui`, `feature/grid-io`).  
- **design** → Branding, UI mockups, icon packs, and non-code assets.  

## Tags
- **App Versions** → `vX.Y` (e.g., `v2.1-stable`, `v2.1.1-branding`).  
- **Script Canon (Project G)** → `chapterX-vY` (e.g., `chapter1-v1.0`).  

## Workflow
1. Develop in `feature/` branches.  
2. Merge into `dev` for testing/integration.  
3. Promote into `main` only when stable and QA-approved.  
4. Tag versions at every stable checkpoint.  
EOF
echo ">>> BRANCHING.md created."

# --- Initialize Git if not already ---
if [ ! -d ".git" ]; then
    git init
    echo ">>> Git repository initialized."
fi

# --- Stage and commit ---
git add .
git commit -m "Initial commit - baseline with .gitignore and branching map"

# --- Setup remote ---
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/Jack-Black27/SHODAN.git

# --- Push main branch ---
git push -u origin main

# --- Tag snapshot and push tag ---
git tag -a "$TAG_NAME" -m "$TAG_MESSAGE"
git push origin "$TAG_NAME"

echo ">>> Repo synced and tagged successfully as $TAG_NAME!"


---

# === Add git-sync helper ===
cat << 'EOF' > ~/.git-sync.sh
#!/bin/bash
# Quick Git sync script

BRANCH="main"

echo "🔄 Syncing with GitHub..."

git pull origin $BRANCH
git add .
if [ -z "$1" ]; then
    COMMIT_MSG="Update from $(date)"
else
    COMMIT_MSG="$1"
fi
git commit -m "$COMMIT_MSG"
git push origin $BRANCH

echo "✅ Sync complete."
EOF

chmod +x ~/.git-sync.sh

# Make it available globally
if [[ "$SHELL" == *"bash" ]]; then
    echo 'alias git-sync="~/.git-sync.sh"' >> ~/.bashrc
elif [[ "$SHELL" == *"zsh" ]]; then
    echo 'alias git-sync="~/.git-sync.sh"' >> ~/.zshrc
fi

echo "✨ You can now use 'git-sync' anywhere!"
