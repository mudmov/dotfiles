set fileformat=unix
set encoding=UTF-8

set nocompatible

set termguicolors
set background=dark
" Syntax highlighting
syntax on
colorscheme slate

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
