return {
  "numToStr/FTerm.nvim",
  config = function()
    vim.keymap.set('n', 'tt', ':lua require("FTerm").toggle()<CR>')
  end
}
