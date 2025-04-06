-- [[ Keybinds ]]
-- Set Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ' '
-- Mac Specific Settings
vim.keymap.set('i', '<M-BS>', '<C-w>') -- delete with options + backspace
vim.keymap.set('i', '<D-BS>', '<C-u>') -- delete with command + backspace
-- Remap escape key
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'JK', '<Esc>')
vim.keymap.set('v', 'jk', '<Esc>')
-- Delete without yanking
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('v', 'x', '"_x')
-- Center after half page jump 
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- Don't lose register when pasting in visual mode
vim.keymap.set('x', 'p', 'pgvy', { noremap = true })
-- Window navigation
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')


-- [[ Settings ]]
-- Relative line numbers enabled
vim.opt.number = true
vim.wo.relativenumber = true
-- Sync system and vim clipboard
vim.opt.clipboard = 'unnamedplus'
-- Delay waiting for multi key commands (e.g. jk to exit) 
vim.opt.timeoutlen = 500  -- (default was 1000ms)
-- Indentation
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 2       -- Size of indent
vim.opt.tabstop = 2          -- Size of tab
vim.opt.softtabstop = 2      -- Number of spaces tab counts for in insert mode
vim.opt.autoindent = true    -- Copy indent from current line
vim.opt.smartindent = true   -- Smart autoindenting on new lines
-- Windows
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Colorscheme
vim.cmd.colorscheme('habamax')
vim.opt.termguicolors = true
-- Hide mode
vim.opt.showmode = false
-- Show which line the cursor is on
vim.opt.cursorline = true
-- Show gutter column
vim.opt.signcolumn = 'yes'
-- Show trails and whitespaces
vim.opt.list = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Set initial scrolloff value
local function update_scrolloff()
  vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0)/2)
end
update_scrolloff()
-- Update scrolloff when window size changes
vim.api.nvim_create_autocmd({'VimResized'}, {
  callback = update_scrolloff,
  desc = 'Update scrolloff when window is resized'
})
-- Disable Neotree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'

-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Move line up or down
for _, mode in ipairs({'n', 'i'}) do
  vim.keymap.set(mode, '<C-j>', '<Esc>:m .+1<CR>==', { noremap = true, silent = true })
  vim.keymap.set(mode, '<C-k>', '<Esc>:m .-2<CR>==', { noremap = true, silent = true })
end
-- Move selected lines up or down in visual mode
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


-- [[ Terminal ]]
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})
-- Terminal mappings
-- vim.o.shell = 'sh' -- uncomment if bash/zsh is too slow
-- vim.keymap.set('n', '<leader>t', ':sp | terminal<CR>i')  -- split above
vim.keymap.set('t', 'jk', '<C-\\><C-n> :hide<CR>')  -- Exit terminal mode


-- [[ Plugins ]]
require("config.lazy")
