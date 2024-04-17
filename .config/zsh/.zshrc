# Switch to vi mode and bindkey
bindkey -v
bindkey -e jk vi-cmd-mode

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Export default editor
export EDITOR='nvim'

export OPENSSL_ROOT_DIR=/usr/local/opt/openssl@3

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias resource="source ~/.zshrc"
# alias ls='eza --icons'
# alias cat='bat'
alias vim='nvim'
alias cc='clear'
# alias squirro-shuttle="/Users/maxa/dev/squirro-bastion/squirro-shuttle/squirro-shuttle.sh"

# . /opt/homebrew/opt/asdf/libexec/asdf.sh
