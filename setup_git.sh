Exactly — better to bulletproof it now than hit a wall mid-push. I’ve added a tag safety check: if the tag you enter already exists locally or remotely, the script warns you and aborts before doing anything destructive.


---

📄 setup_git.sh (final with tag safety check)

#!/bin/bash
# ----------------------------------------
# GitHub Project Setup Script for SHODAN
# Repo: https://github.com/Jack-Black27/SHODAN
# ----------------------------------------

set -e  # Exit immediately if a command fails

echo ">>> Setting up SHODAN repo..."

# Ask user for version tag
read -p "Enter version tag (e.g. v2.1.1-branding): " TAG_NAME
read -p "Enter tag message (e.g. Branding & Icon Pack release): " TAG_MESSAGE

# --- Safety check for existing tag ---
if git show-ref --tags | grep -q "refs/tags/$TAG_NAME"; then
    echo "ERROR: Tag '$TAG_NAME' already exists locally. Choose another name."
    exit 1
fi

if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME"; then
    echo "ERROR: Tag '$TAG_NAME' already exists on remote. Choose another name."
    exit 1
fi

# --- Create .gitignore ---
cat > .gitignore <<'EOF'
# -------------------------
# OS / Editor junk
# -------------------------
.DS_Store
Thumbs.db
*.log
*.tmp
*.swp
*.swo
.vscode/
.idea/

# -------------------------
# Python (Grid Translator App)
# -------------------------
__pycache__/
*.pyc
*.pyo
*.pyd
env/
venv/
*.egg-info/
dist/
build/

# -------------------------
# Unreal Engine 5 (Project G)
# -------------------------
Binaries/
DerivedDataCache/
Intermediate/
Saved/
.vs/
*.sln
*.opensdf
*.sdf
*.suo
*.xcodeproj
*.xcworkspace

# Ignore build output folders
*.app
*.ipa
*.exe
*.dll
*.dylib
*.so

# -------------------------
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

Now the workflow is bulletproof:

If you try to reuse a tag name, it stops and tells you to pick another.

Prevents both local duplicate tags and remote tag collisions.

Everything else flows exactly the same.


Would you like me to also make it multi-tag aware — so you can input multiple tags in one run (e.g. v2.1.1-branding and chapter1-v1.0) and it applies them both?

