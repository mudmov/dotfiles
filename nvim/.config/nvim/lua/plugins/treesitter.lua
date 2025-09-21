return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
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
            -- Functions
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- Classes
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- Parameters/arguments
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            -- Conditionals (if/else)
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            -- Loops
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            -- Comments
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            -- Blocks
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            -- Assignments
            ["a="] = "@assignment.outer",
            ["i="] = "@assignment.inner",
            -- Calls
            ["aF"] = "@call.outer",
            ["iF"] = "@call.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]o"] = "@loop.*",
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
            ["]O"] = "@loop.*",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[o"] = "@loop.*",
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[O"] = "@loop.*",
          },
        },
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
