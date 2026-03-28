#!/usr/bin/env bash
# One-liner dotfiles installer:
#   curl -fsSL https://raw.githubusercontent.com/mudmov/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO="https://github.com/mudmov/dotfiles.git"
BRANCH="${DOTFILES_BRANCH:-main}"

if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles already cloned at $DOTFILES_DIR, pulling latest..."
  git -C "$DOTFILES_DIR" checkout "$BRANCH"
  git -C "$DOTFILES_DIR" pull
else
  echo "Cloning dotfiles (branch: $BRANCH)..."
  git clone -b "$BRANCH" "$REPO" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"
chmod +x install.sh
exec ./install.sh "$@"
