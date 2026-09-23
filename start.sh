#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/nicolaj-hartmann/bootstrap-mac.git"
REPO_PATH="$HOME/bootstrap-mac"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools, accept the dialog and wait for it to finish"
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

BREW=/opt/homebrew/bin/brew
[ "$(uname -m)" = "x86_64" ] && BREW=/usr/local/bin/brew
if [ ! -x "$BREW" ]; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$("$BREW" shellenv)"
touch "$HOME/.zprofile"
grep -q 'brew shellenv' "$HOME/.zprofile" || echo "eval \"\$($BREW shellenv)\"" >> "$HOME/.zprofile"

for t in gh ansible; do command -v "$t" >/dev/null || brew install "$t"; done

if ! gh auth status >/dev/null 2>&1; then
  gh auth login --hostname github.com --git-protocol https --web --scopes user:email
fi
gh auth setup-git

if [ ! -d "$REPO_PATH/.git" ]; then
  git clone "$REPO_URL" "$REPO_PATH"
fi

cd "$REPO_PATH"
exec ansible-playbook setup.yml --ask-become-pass
