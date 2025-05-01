return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
  },
  lazy = false,
  cmd = 'Telescope',
  config = function()
    local lga_actions = require('telescope-live-grep-args.actions')
    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { prompt_position = 'bottom' },
        sorting_strategy = 'ascending',
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        ['live_grep_args'] = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
            }
          },
          additional_args = function()
            return { "--fixed-strings", "--hidden" }
          end
        }
      },
    })
    -- Load extensions
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('live_grep_args')

    local builtin = require('telescope.builtin')
    local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
    local lgwa = function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end

    -- Keymaps
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp Doc' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ hidden = true }) end, { desc = '[F]ind [F]ile' })
    vim.keymap.set('n', '<leader>fw', lga_shortcuts.grep_word_under_cursor, { desc = '[F]ind Current [W]ord' })
    vim.keymap.set('v', '<leader>fw', lga_shortcuts.grep_visual_selection, { desc = '[F]ind Selected [W]ords' })
    vim.keymap.set('n', '<leader>f/', lgwa, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Vim Buffers' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recently Closed' })
    vim.keymap.set('n', '<leader>fp', function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end, { desc = '[F]ind [P]lugin Config' })
  end,
}
