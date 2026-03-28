#!/usr/bin/env bash
# Dependencies for aerospace (macOS only)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

if [[ "$(detect_os)" != "macos" ]]; then
  log_warn "aerospace is macOS-only, skipping on Linux"
  return 0 2>/dev/null || exit 0
fi

DESCRIPTION="Tiling window manager for macOS"
MACOS_ONLY=true
DEPS=()

setup() {
  log_info "Installing AeroSpace via brew cask..."
  install_cask nikitabobko/tap/aerospace
}
