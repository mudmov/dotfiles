# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). One command to install everything — dependencies included.

## Quick Start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Install specific packages
./install.sh nvim tmux zsh

# Or run with no args for an interactive menu
./install.sh
```

That's it. The script handles OS detection, installs dependencies, and symlinks configs to the right places.

## How It Works

Each top-level folder is a **stow package** — its contents mirror your home directory structure. When you run `stow nvim`, it symlinks `nvim/.config/nvim/` → `~/.config/nvim/`.

Each package has a `deps.sh` manifest that declares:
- **`DEPS`** — system packages to install (via brew/apt/dnf/pacman)
- **`setup()`** — post-install steps (cloning plugin managers, etc.)

The `install.sh` script orchestrates everything: detects your OS and package manager, installs deps, runs setup, then stows.

## Packages

| Package | What it configures | Key dependencies |
|---------|-------------------|-----------------|
| **zsh** | Shell config, oh-my-zsh, vi mode, aliases | zsh, fzf, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting, nvm |
| **tmux** | Terminal multiplexer, catppuccin theme, vim-style navigation | tmux, tpm (plugin manager) |
| **nvim** | Neovim with Lazy.nvim, LSP, treesitter, telescope | neovim, ripgrep, fd, gcc, make, node, python3, stylua, prettier |
| **ghostty** | Ghostty terminal config | ghostty (macOS only) |
| **aerospace** | Tiling window manager config | aerospace (macOS only) |
| **hammerspoon** | macOS automation | hammerspoon (macOS only) |

## Usage

```bash
# Install specific packages with all their dependencies
./install.sh nvim tmux

# Interactive menu (no args)
./install.sh

# Remove symlinks for a package
./install.sh --uninstall nvim

# Re-link after adding new dotfiles to a package
./install.sh --restow nvim
```

## Supported Platforms

- **macOS** — uses Homebrew (brew/brew cask)
- **Linux** — supports apt (Debian/Ubuntu), dnf (Fedora), pacman (Arch)

macOS-only packages (aerospace, ghostty, hammerspoon) skip gracefully on Linux.

## Adding a New Package

1. Create a folder matching the tool name (e.g. `alacritty/`)
2. Mirror the home directory structure inside it (e.g. `alacritty/.config/alacritty/alacritty.toml`)
3. Add a `deps.sh` with dependencies and setup:

```bash
DEPS=(alacritty)

setup() {
  # Any post-install setup goes here
  :
}
```

4. Run `./install.sh alacritty`

## Structure

```
~/dotfiles/
├── install.sh           # Main entry point
├── lib/common.sh        # OS detection, pkg helpers, logging
├── zsh/
│   ├── deps.sh          # Dependencies + setup
│   └── .zshrc           # → ~/.zshrc
├── tmux/
│   ├── deps.sh
│   └── .tmux.conf       # → ~/.tmux.conf
├── nvim/
│   ├── deps.sh
│   └── .config/nvim/    # → ~/.config/nvim/
├── aerospace/
│   ├── deps.sh
│   └── .config/aerospace/
├── ghostty/
│   ├── deps.sh
│   └── .config/ghostty/
└── hammerspoon/
    ├── deps.sh
    └── .hammerspoon/    # → ~/.hammerspoon/
```
