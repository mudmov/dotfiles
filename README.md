## Installation Manual
1. Install `stow` using package manager
2. Install all programs you have/want to apply dotfiles to (e.g. tmux, zsh...)
3. Pull dotfiles folder into home directory
4. Run `stow tmux zsh <whatever_else>` from withing the dotfiles directory
5. Re-source

## Additional Notes

### ZSH
- For `zsh` you have to install `oh-my-zsh`
- `oh-my-zsh` replaces the `.zshrc` so make sure that your `.zshrc` has not been replaced post installation
- we are also installing `zsh-autosuggestions` and `zsh-syntax-highlighting` so will need to be installed
- For tmux you have to install `tpm`

(will need to write a script for these to automate)

### Nvim
Installation:
```bash
appimage installation instructions & symlinking...
chmod u+x ...
```
Requires:
```txt
make
nodejs
ripgrep
fzf
gcc
```
