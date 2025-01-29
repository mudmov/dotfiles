# Switch to vi mode and bindkey
bindkey -v
bindkey -e jk vi-cmd-mode

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Export default editor
export EDITOR='nvim'

# Aliases
alias nf='nvim $(fzf -m --preview="cat {}")'
alias zsource="source $HOME/.zshrc"
alias cc='clear'

# Ghostty issues when connecting to remote
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

# Plugins
source $ZSH/oh-my-zsh.sh
if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH_THEME="af-magic"
    export ZSH="$HOME/.oh-my-zsh"

    plugins=(
        git
        zsh-syntax-highlighting
        zsh-autosuggestions
    )

    source $ZSH/oh-my-zsh.sh
fi
