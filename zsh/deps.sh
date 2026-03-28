#!/usr/bin/env bash
# ZSH package dependencies

DESCRIPTION="Zsh shell with oh-my-zsh, autosuggestions, syntax highlighting, nvm"
DEPS=(zsh fzf zoxide fd)

setup() {
  local ZSH_DIR="${HOME}/.oh-my-zsh"
  local ZSH_CUSTOM="${ZSH_DIR}/custom"

  # Install oh-my-zsh if not present
  if [[ ! -d "$ZSH_DIR" ]]; then
    log_info "Installing oh-my-zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    log_info "oh-my-zsh already installed"
  fi

  # Clone zsh-autosuggestions
  local auto_dir="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
  if [[ ! -d "$auto_dir" ]]; then
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$auto_dir"
  else
    log_info "zsh-autosuggestions already installed"
  fi

  # Clone zsh-syntax-highlighting
  local syntax_dir="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
  if [[ ! -d "$syntax_dir" ]]; then
    log_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$syntax_dir"
  else
    log_info "zsh-syntax-highlighting already installed"
  fi

  # Install nvm
  if [[ ! -d "${HOME}/.nvm" ]]; then
    log_info "Installing nvm..."
    PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
  else
    log_info "nvm already installed"
  fi

  # Ensure ~/.secrets exists (sourced by .zshrc)
  [[ -f "$HOME/.secrets" ]] || touch "$HOME/.secrets"

  # Back up any existing .zshrc so stow can create symlink
  if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    log_warn "Backing up existing ~/.zshrc to ~/.zshrc.bak"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  fi
}
