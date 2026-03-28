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

# Discover available packages (dirs containing a stow-style dotfile tree)
available_packages() {
  local pkg
  for pkg in "$DOTFILES_DIR"/*/; do
    pkg="$(basename "$pkg")"
    [[ "$pkg" == "lib" ]] && continue
    echo "$pkg"
  done
}

# Interactive menu when no args given
select_packages() {
  local packages=()
  mapfile -t packages < <(available_packages)
  log_info "Available packages:"
  PS3="Enter numbers (space-separated) or 'a' for all: "
  select pkg in "${packages[@]}" "ALL"; do
    if [[ "$pkg" == "ALL" || "$REPLY" == "a" ]]; then
      SELECTED=("${packages[@]}")
    else
      SELECTED=("$pkg")
    fi
    break
  done
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
