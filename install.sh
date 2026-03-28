#!/usr/bin/env bash
# Dotfiles bootstrap installer
# Usage: ./install.sh [--uninstall|--restow] [package ...]
# No args: interactive menu

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/lib/common.sh"

MODE="install"  # install | uninstall | restow

# Parse flags
while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --uninstall) MODE="uninstall"; shift ;;
    --restow)   MODE="restow"; shift ;;
    *)           log_error "Unknown flag: $1"; exit 1 ;;
  esac
done

# Get description for a package from its deps.sh
get_pkg_description() {
  local pkg="$1"
  local deps_file="$DOTFILES_DIR/$pkg/deps.sh"
  if [[ -f "$deps_file" ]]; then
    local desc
    desc="$(grep '^DESCRIPTION=' "$deps_file" | head -1 | sed 's/^DESCRIPTION="//' | sed 's/"$//')"
    echo "${desc:-No description}"
  else
    echo "No description"
  fi
}

# Check if a package is macOS-only
is_macos_only() {
  local pkg="$1"
  local deps_file="$DOTFILES_DIR/$pkg/deps.sh"
  [[ -f "$deps_file" ]] && grep -q '^MACOS_ONLY=true' "$deps_file"
}

# Discover available packages, filtered by OS
available_packages() {
  local pkg current_os
  current_os="$(detect_os)"
  for pkg in "$DOTFILES_DIR"/*/; do
    pkg="$(basename "$pkg")"
    [[ "$pkg" == "lib" ]] && continue
    # Hide macOS-only packages on Linux
    if [[ "$current_os" != "macos" ]] && is_macos_only "$pkg"; then
      continue
    fi
    echo "$pkg"
  done
}

# Interactive menu when no args given
select_packages() {
  local packages=() descriptions=()
  mapfile -t packages < <(available_packages)

  echo ""
  log_info "Available packages:"
  echo ""
  local i
  for i in "${!packages[@]}"; do
    local desc
    desc="$(get_pkg_description "${packages[$i]}")"
    printf "  %s) %s — %s\n" "$((i + 1))" "${packages[$i]}" "$desc"
  done
  echo ""
  printf "Enter numbers (space-separated) or 'a' for all: "
  read -r reply

  if [[ "$reply" == "a" || "$reply" == "A" ]]; then
    SELECTED=("${packages[@]}")
  else
    SELECTED=()
    for num in $reply; do
      local idx=$((num - 1))
      if [[ $idx -ge 0 && $idx -lt ${#packages[@]} ]]; then
        SELECTED+=("${packages[$idx]}")
      else
        log_warn "Invalid selection: $num"
      fi
    done
  fi

  if [[ ${#SELECTED[@]} -eq 0 ]]; then
    log_error "No packages selected"
    exit 1
  fi
}

run_stow() {
  local pkg="$1"
  case "$MODE" in
    install)   stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
    uninstall) stow -v -D -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
    restow)    stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
  esac
}

process_package() {
  local pkg="$1"
  local deps_file="$DOTFILES_DIR/$pkg/deps.sh"

  log_info "Processing package: $pkg ($MODE)"

  if [[ "$MODE" == "uninstall" ]]; then
    run_stow "$pkg"
    log_success "Unstowed $pkg"
    return
  fi

  # Source deps.sh if it exists
  if [[ -f "$deps_file" ]]; then
    log_info "Sourcing $pkg/deps.sh..."
    (
      source "$deps_file"
      # Install system dependencies
      if declare -p DEPS &>/dev/null 2>&1; then
        for dep in "${DEPS[@]}"; do
          if ! command -v "$dep" &>/dev/null; then
            log_info "Installing dependency: $dep"
            install_pkg "$dep"
          else
            log_success "Dependency already installed: $dep"
          fi
        done
      fi
      # Run setup function if defined
      if declare -f setup &>/dev/null; then
        log_info "Running setup for $pkg..."
        setup
      fi
    )
  fi

  run_stow "$pkg"
  log_success "Stowed $pkg"
}

main() {
  log_info "Dotfiles installer ($(detect_os), $(detect_pkg_manager))"
  ensure_stow

  local SELECTED=()

  if [[ $# -gt 0 ]]; then
    SELECTED=("$@")
  else
    select_packages
  fi

  for pkg in "${SELECTED[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      log_warn "Package '$pkg' not found, skipping"
      continue
    fi
    process_package "$pkg"
  done

  log_success "Done!"
}

main "$@"
