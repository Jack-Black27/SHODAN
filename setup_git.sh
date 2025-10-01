#!/bin/bash
# ----------------------------------------
# GitHub Project Setup Script for SHODAN
# Repo: https://github.com/Jack-Black27/SHODAN
# ----------------------------------------

# Exit immediately if a command fails
set -e

echo ">>> Setting up SHODAN repo..."

# Create .gitignore
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

# Create BRANCHING.md
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

# Initialize Git
if [ ! -d ".git" ]; then
    git init
    echo ">>> Git repository initialized."
fi

# Stage and commit
git add .
git commit -m "Initial commit - baseline with .gitignore and branching map"

# Link remote and push
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/Jack-Black27/SHODAN.git
git push -u origin main

echo ">>> Repo synced successfully!"
