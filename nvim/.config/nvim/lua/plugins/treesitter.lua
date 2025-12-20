return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "master",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- 1. Force the require to ensure module is loaded
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    -- 2. Setup
    configs.setup({
      ensure_installed = {
        "python", "lua", "javascript", "html", "bash", "dockerfile",
        "json", "markdown", "nginx", "sql", "yaml", "css",
        "typescript", "tsx", "vim", "vimdoc", "regex", "query"
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },

      -- Textobjects configuration inside the main setup
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
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    })
  end,
}
