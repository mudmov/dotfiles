return {
  "numToStr/FTerm.nvim",
  config = function()
    vim.keymap.set('n', '<leader>tt', ':lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
  end
}
