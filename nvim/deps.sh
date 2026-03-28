#!/usr/bin/env bash
# Neovim package dependencies

DESCRIPTION="Neovim editor with LSP, treesitter, telescope"

# Package names vary by OS/package manager
_os="$(detect_os)"
_mgr="$(detect_pkg_manager)"

DEPS=(git ripgrep make python3 node npm curl)

# Add OS-specific package names
# Note: stylua and prettier are handled by Mason inside Neovim, not system packages
# Note: neovim is installed via AppImage on Linux (apt/dnf/pacman ship outdated versions)
if [[ "$_mgr" == "brew" ]]; then
  DEPS+=(neovim fd gcc)
elif [[ "$_mgr" == "apt" ]]; then
  DEPS+=(fd-find gcc python3-pip build-essential)
elif [[ "$_mgr" == "dnf" ]]; then
  DEPS+=(fd-find gcc python3-pip)
elif [[ "$_mgr" == "pacman" ]]; then
  DEPS+=(fd gcc python3-pip)
fi

install_nvim_appimage() {
  local target="$HOME/.local/bin/nvim"
  mkdir -p "$HOME/.local/bin"

  # Skip if nvim is already 0.11+
  if command -v nvim &>/dev/null; then
    local ver
    ver="$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+')"
    if [[ "$(printf '%s\n' "0.11" "$ver" | sort -V | head -1)" == "0.11" ]]; then
      log_info "Neovim $ver already installed, skipping AppImage download"
      return 0
    fi
  fi

  local tmpdir
  tmpdir="$(mktemp -d)"

  log_info "Downloading latest Neovim AppImage..."
  curl -fsSL -o "$tmpdir/nvim.appimage" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod u+x "$tmpdir/nvim.appimage"

  # Extract instead of running directly — avoids FUSE dependency on servers
  log_info "Extracting AppImage (no FUSE required)..."
  cd "$tmpdir" && ./nvim.appimage --appimage-extract >/dev/null 2>&1
  rm -rf "$HOME/.local/lib/nvim-squashfs"
  mv "$tmpdir/squashfs-root" "$HOME/.local/lib/nvim-squashfs"
  ln -sf "$HOME/.local/lib/nvim-squashfs/usr/bin/nvim" "$target"
  rm -rf "$tmpdir"

  log_success "Neovim installed to $target"
}

setup() {
  # Install Neovim via AppImage on Linux
  if [[ "$_os" != "macos" ]]; then
    install_nvim_appimage
  fi

  # Run headless Lazy sync to install plugins
  log_info "Running Neovim headless Lazy sync..."
  nvim --headless '+Lazy! sync' +qa 2>/dev/null || true
  log_success "Neovim plugins synced"
}
