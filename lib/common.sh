#!/usr/bin/env bash
# Shared helpers for dotfiles bootstrap

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { printf "${BLUE}[INFO]${NC} %s\n" "$*"; }
log_success() { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
log_warn()    { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }
log_error()   { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

detect_pkg_manager() {
  if command -v brew &>/dev/null; then echo "brew"
  elif command -v apt &>/dev/null; then echo "apt"
  elif command -v dnf &>/dev/null; then echo "dnf"
  elif command -v pacman &>/dev/null; then echo "pacman"
  else echo "unknown"
  fi
}

install_pkg() {
  local pkg="$1"
  local mgr
  mgr="$(detect_pkg_manager)"

  case "$mgr" in
    brew)   brew install "$pkg" ;;
    apt)    sudo apt install -y "$pkg" ;;
    dnf)    sudo dnf install -y "$pkg" ;;
    pacman) sudo pacman -S --noconfirm "$pkg" ;;
    *)      log_error "Unknown package manager"; return 1 ;;
  esac
}

install_cask() {
  brew install --cask "$1"
}

ensure_stow() {
  if ! command -v stow &>/dev/null; then
    log_info "Installing GNU Stow..."
    install_pkg stow
  fi
}
