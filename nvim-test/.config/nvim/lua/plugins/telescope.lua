return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  cmd = 'Telescope',
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>', desc = '[F]ind [F]ile' },
    { '<leader>fw', '<cmd>Telescope grep_string hidden=true<cr>', desc = '[F]ind current [W] word' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = '[F]ind by [G]rep' },
    { '<leader><leader>', '<cmd>Telescope buffers<cr>', desc = 'Vim Buffers' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = '[F]ind [R]ecent files' },
    { '<leader>fl',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'test'
    },
  },
  opts = {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = { prompt_position = 'bottom' },
      sorting_strategy = 'ascending',
    },
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }
    require("telescope").load_extension("ui-select")
  end,
}
