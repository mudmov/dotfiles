local opt = vim.opt
local keymap = vim.keymap.set

-- [[ Keybinds ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Mac Specific Settings
keymap('i', '<M-BS>', '<C-w>')
keymap('i', '<D-BS>', '<C-u>')

-- Remap escape key
keymap('i', 'jk', '<Esc>')
keymap('i', 'JK', '<Esc>')
keymap('t', 'jk', '<C-\\><C-n><cmd>hide<cr>')

-- Center after half page jump
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')

-- Don't lose register when pasting in visual mode
keymap('x', 'p', 'P')

-- Window navigation (tmux sends these when it detects vim)
keymap('n', '<c-h>', '<c-w>h')
keymap('n', '<c-j>', '<c-w>j')
keymap('n', '<c-k>', '<c-w>k')
keymap('n', '<c-l>', '<c-w>l')

-- Reload config
keymap({'n', 'i', 'v'}, '<leader>rr', function() vim.cmd.source(vim.env.MYVIMRC) end)

-- Clear search highlighting
keymap('n', '<Esc>', function()
  vim.fn.setreg('/', '')
  vim.cmd.nohlsearch()
end, { silent = true })

-- Toggle diagnostic virtual lines
keymap('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

-- Terminal-like line navigation
keymap('n', '<C-a>', '^')
keymap('n', '<C-e>', '$')

-- Quick close buffer
keymap('n', '<leader>q', '<cmd>bd<cr>')

-- [[ Settings ]]
opt.number = true
opt.relativenumber = true
opt.swapfile = false
opt.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

opt.timeoutlen = 500
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.showmode = false
opt.cursorline = true
opt.signcolumn = 'yes'
opt.fillchars:append({ eob = " " })
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

local function update_scrolloff()
  opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 2)
end
update_scrolloff()

vim.api.nvim_create_autocmd('VimResized', {
  callback = update_scrolloff,
  desc = 'Update scrolloff when window is resized',
})

-- Disable netrw (Oil handles file browsing)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = 'split'

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- [[ Plugins ]]
require("config.lazy")
