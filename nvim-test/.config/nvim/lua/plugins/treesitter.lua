return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = {
            "python",
            "lua",
            "javascript",
            "html",
            "bash",
            "dockerfile",
            "json",
            "markdown",
            "nginx",
            "sql",
            "yaml",
            "css",
            "typescript",
            "tsx",
            "vim",
            "vimdoc",
            "regex",
            "query"
          },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
          textobjects = {
            enable = true,
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
            },
          },
        })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
}
