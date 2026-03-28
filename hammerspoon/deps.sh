#!/usr/bin/env bash
# Dependencies for hammerspoon (macOS only)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

if [[ "$(detect_os)" != "macos" ]]; then
  log_warn "hammerspoon is macOS-only, skipping on Linux"
  return 0 2>/dev/null || exit 0
fi

DESCRIPTION="macOS automation with Lua scripting"
MACOS_ONLY=true
DEPS=()

setup() {
  log_info "Installing Hammerspoon via brew cask..."
  install_cask hammerspoon
}
