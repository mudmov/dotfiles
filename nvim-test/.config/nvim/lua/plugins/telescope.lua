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
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
  },
  opts = {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = { prompt_position = 'top' },
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
