set fileformat=unix
set encoding=UTF-8

set nocompatible

" Remap escape key
inoremap jk <ESC>
let mapleader = " "

" Always center half page jumps
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Always center vertical navigation
nnoremap n nzzzv
nnoremap N Nzzzv

" Set autoreload when file is changed
set autoread
au CursorHold * checktime

" Syntax highlighting
syntax on

" Relative line numbers when in normal mode
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set rnu

" Line cursor changing from cursor to block
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

set signcolumn=yes
set scrolloff=8
set number
set cursorline
set showcmd
set noshowmode

set noswapfile
set nobackup
set noerrorbells visualbell t_vb=
set undodir=~/.vim/undodir
set undofile

set ignorecase
set smartcase
set incsearch
set hlsearch
set spell spelllang=en_us

set nowrap
set list
set listchars=eol:.,tab:>-,trail:~,extends:>,precedes:<

set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set clipboard=unnamed

so ~/.vim/plugins.vim
so ~/.vim/plugin-config.vim

"-- COLOR & THEME CONFIG
set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
hi Normal guibg=NONE ctermbg=NONE
let g:terminal_ansi_colors = [
    \ '#282828', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#a89984',
    \ '#928374', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2',
\]
