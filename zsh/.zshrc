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
alias zsource="source $HOME/.zshrc"
alias cc='clear'

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

# Fuzzy find and open files in Neovim
ff() {
    local search_dir="${1:-.}"  # Default to current directory if no argument
    local target_file
    
    # Use find to get files and pipe to fzf for fuzzy search
    target_file=$(find "$search_dir" -type f 2>/dev/null | fzf)
    
    # If a file was selected, open it in Neovim
    if [[ -n "$target_file" ]]; then
        nvim "$target_file"
    fi
}

# fuzzy funder required
fd() {
    local search_dir="${1:-.}"  # Default to current directory if no argument
    local target_dir
    
    # Use find to get directories and pipe to fzf for fuzzy search
    target_dir=$(find "$search_dir" -type d 2>/dev/null | fzf)
    
    # If a directory was selected, cd into it
    if [[ -n "$target_dir" ]]; then
        cd "$target_dir"
    fi
}
