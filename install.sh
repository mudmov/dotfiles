#!/usr/bin/env bash
# Dotfiles bootstrap installer
# Usage: ./install.sh [--help|--check|--uninstall|--restow] [package ...]
# No args: interactive menu

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/lib/common.sh"

MODE="install"  # install | uninstall | restow | check | help

# Parse flags
while [[ "${1:-}" == -* ]]; do
  case "$1" in
    --uninstall) MODE="uninstall"; shift ;;
    --restow)   MODE="restow"; shift ;;
    --check)    MODE="check"; shift ;;
    --help|-h)  MODE="help"; shift ;;
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
    install)   stow -v --ignore='deps\.sh' -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
    uninstall) stow -v --ignore='deps\.sh' -D -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
    restow)    stow -v --ignore='deps\.sh' -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg" ;;
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

  local dep_failures=()

  # Source deps.sh if it exists
  if [[ -f "$deps_file" ]]; then
    log_info "Sourcing $pkg/deps.sh..."
    source "$deps_file"

    # Install system dependencies
    if declare -p DEPS &>/dev/null; then
      for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
          log_info "Installing dependency: $dep"
          if ! install_pkg "$dep"; then
            local mgr
            mgr="$(detect_pkg_manager)"
            log_error "Failed to install dep '$dep' via $mgr for package '$pkg'"
            dep_failures+=("$dep")
          fi
        else
          log_success "Dependency already installed: $dep"
        fi
      done
    fi

    # Run setup function if defined (even if some deps failed)
    if declare -f setup &>/dev/null; then
      log_info "Running setup for $pkg..."
      if ! setup; then
        log_error "Setup failed for package '$pkg'"
        dep_failures+=("setup()")
      fi
    fi

    # Clean up sourced variables/functions to avoid leaking between packages
    unset DEPS DESCRIPTION MACOS_ONLY 2>/dev/null || true
    unset -f setup 2>/dev/null || true
  fi

  # Stow even if deps failed
  run_stow "$pkg"
  log_success "Stowed $pkg"

  if [[ ${#dep_failures[@]} -gt 0 ]]; then
    log_warn "Package '$pkg' had failures: ${dep_failures[*]}"
    LAST_PKG_FAILURES="${dep_failures[*]}"
    return 1
  fi
  LAST_PKG_FAILURES=""
}

print_summary() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Summary"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  local pkg
  for pkg in "${SUMMARY_SUCCESS[@]:-}"; do
    [[ -n "$pkg" ]] && printf "  ${GREEN}✔${NC}  %s\n" "$pkg"
  done
  for pkg in "${SUMMARY_WARN[@]:-}"; do
    [[ -n "$pkg" ]] && printf "  ${YELLOW}⚠${NC}  %s — failures: %s\n" "$pkg" "${SUMMARY_WARN_DETAILS[$pkg]:-unknown}"
  done
  for pkg in "${SUMMARY_FAIL[@]:-}"; do
    [[ -n "$pkg" ]] && printf "  ${RED}✘${NC}  %s — %s\n" "$pkg" "${SUMMARY_FAIL_DETAILS[$pkg]:-failed}"
  done

  echo ""
}

show_help() {
  echo "Dotfiles Bootstrap Installer"
  echo ""
  echo "Usage: ./install.sh [flags] [package ...]"
  echo ""
  echo "Flags:"
  echo "  --help, -h     Show this help message"
  echo "  --check        Check which deps are installed vs missing"
  echo "  --uninstall    Unstow selected packages"
  echo "  --restow       Restow selected packages"
  echo ""
  echo "Examples:"
  echo "  ./install.sh                 # Interactive menu"
  echo "  ./install.sh tmux zsh        # Install specific packages"
  echo "  ./install.sh --check         # Check all packages"
  echo "  ./install.sh --check nvim    # Check nvim deps only"
  echo "  ./install.sh --uninstall zsh # Unstow zsh"
  echo ""
  echo "Available packages:"
  local pkg
  while IFS= read -r pkg; do
    local desc
    desc="$(get_pkg_description "$pkg")"
    printf "  %-15s %s\n" "$pkg" "$desc"
  done < <(available_packages)
}

check_packages() {
  local packages=("$@")
  if [[ ${#packages[@]} -eq 0 ]]; then
    mapfile -t packages < <(available_packages)
  fi

  local any_missing=0
  for pkg in "${packages[@]}"; do
    local deps_file="$DOTFILES_DIR/$pkg/deps.sh"
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      log_error "Package '$pkg' not found"
      any_missing=1
      continue
    fi
    if [[ ! -f "$deps_file" ]]; then
      log_info "$pkg: no deps.sh"
      continue
    fi

    # Source deps.sh to get DEPS array
    (
      source "$deps_file"
      if ! declare -p DEPS &>/dev/null; then
        echo "  $pkg: no DEPS defined"
        exit 0
      fi
      local missing=() installed=()
      for dep in "${DEPS[@]}"; do
        if command -v "$dep" &>/dev/null; then
          installed+=("$dep")
        else
          missing+=("$dep")
        fi
      done
      if [[ ${#missing[@]} -eq 0 ]]; then
        printf "  ${GREEN}✔${NC}  %s — all deps installed (%s)\n" "$pkg" "${installed[*]}"
      else
        printf "  ${YELLOW}⚠${NC}  %s — missing: %s" "$pkg" "${missing[*]}"
        if [[ ${#installed[@]} -gt 0 ]]; then
          printf ", installed: %s" "${installed[*]}"
        fi
        printf "\n"
        exit 1
      fi
    ) || any_missing=1
    unset DEPS DESCRIPTION MACOS_ONLY 2>/dev/null || true
    unset -f setup 2>/dev/null || true
  done

  return "$any_missing"
}

main() {
  if [[ "$MODE" == "help" ]]; then
    show_help
    exit 0
  fi

  if [[ "$MODE" == "check" ]]; then
    log_info "Checking dependencies ($(detect_os), $(detect_pkg_manager))"
    echo ""
    check_packages "$@"
    exit $?
  fi

  log_info "Dotfiles installer ($(detect_os), $(detect_pkg_manager))"
  ensure_stow

  local SELECTED=()

  if [[ $# -gt 0 ]]; then
    SELECTED=("$@")
  else
    select_packages
  fi

  # Summary tracking arrays
  SUMMARY_SUCCESS=()
  SUMMARY_WARN=()
  SUMMARY_FAIL=()
  declare -A SUMMARY_WARN_DETAILS
  declare -A SUMMARY_FAIL_DETAILS
  local any_failures=0

  for pkg in "${SELECTED[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      log_warn "Package '$pkg' not found, skipping"
      SUMMARY_FAIL+=("$pkg")
      SUMMARY_FAIL_DETAILS["$pkg"]="not found"
      any_failures=1
      continue
    fi
    if ! process_package "$pkg"; then
      # Package had some dep/setup failures but stow still ran
      SUMMARY_WARN+=("$pkg")
      SUMMARY_WARN_DETAILS["$pkg"]="${LAST_PKG_FAILURES:-unknown}"
      any_failures=1
    else
      SUMMARY_SUCCESS+=("$pkg")
    fi
  done

  print_summary

  if [[ "$any_failures" -eq 1 ]]; then
    exit 1
  fi
}

main "$@"
