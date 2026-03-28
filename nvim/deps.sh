#!/usr/bin/env bash
# Neovim package dependencies

# Package names vary by OS/package manager
_os="$(detect_os)"
_mgr="$(detect_pkg_manager)"

DEPS=(git ripgrep make python3 node npm)

# Add OS-specific package names
if [[ "$_mgr" == "brew" ]]; then
  DEPS+=(neovim fd gcc stylua prettier)
elif [[ "$_mgr" == "apt" ]]; then
  DEPS+=(neovim fd-find gcc python3-pip stylua prettier)
elif [[ "$_mgr" == "dnf" ]]; then
  DEPS+=(neovim fd-find gcc python3-pip stylua prettier)
elif [[ "$_mgr" == "pacman" ]]; then
  DEPS+=(neovim fd gcc python3-pip stylua prettier)
fi

setup() {
  # Run headless Lazy sync to install plugins
  log_info "Running Neovim headless Lazy sync..."
  nvim --headless '+Lazy! sync' +qa 2>/dev/null || true
  log_success "Neovim plugins synced"
}
