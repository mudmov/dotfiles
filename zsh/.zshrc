# Switch to vi mode and bindkey
bindkey -v
bindkey -e jk vi-cmd-mode

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Export default editor
export EDITOR='nvim'

export OPENSSL_ROOT_DIR=/usr/local/opt/openssl@3

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

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
alias nf='nvim $(fzf -m --preview="cat {}")'
alias zsource="source $HOME/.zshrc"
alias tsource="tmux source-file $HOME/dotfiles/tmux/tmux.conf"
# alias ls='eza --icons'
# alias cat='bat'
alias vim='nvim'
alias cc='clear'
# alias squirro-shuttle="/Users/maxa/dev/squirro-bastion/squirro-shuttle/squirro-shuttle.sh"

# . /opt/homebrew/opt/asdf/libexec/asdf.sh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
