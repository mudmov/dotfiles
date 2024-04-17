# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Switch to vi mode and bindkey
bindkey -v
bindkey -e jk vi-cmd-mode

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Export default editor
export EDITOR='nvim'

export OPENSSL_ROOT_DIR=/usr/local/opt/openssl@3

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
alias squirro-shuttle="/Users/maxa/dev/squirro-bastion/squirro-shuttle/squirro-shuttle.sh"

. /opt/homebrew/opt/asdf/libexec/asdf.sh
