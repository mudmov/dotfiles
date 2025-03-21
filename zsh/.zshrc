# Speeding up omz
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Smarter completion initialization
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# Switch to vi mode and bindkey
bindkey -v
bindkey -e jk vi-cmd-mode

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Export default editor
export EDITOR='nvim'

# Aliases
alias nf='nvim $(fzf -m --preview="cat {}")'
alias zsource="source $HOME/.zshrc"
alias cc='clear'
alias svim='sudoedit'


# Ghostty issues when connecting to remote
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

# Plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH_THEME="af-magic"
    export ZSH="$HOME/.oh-my-zsh"

    plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    source $ZSH/oh-my-zsh.sh
fi
