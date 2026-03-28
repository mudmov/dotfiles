local lsp_servers = {
  "lua_ls",
  "bashls",
  "dockerls",
  "jsonls",
  "ruff",
  "pyright",
  "yamlls",
  "vtsls",
  "biome"
}

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
        automatic_enable = false,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- NATIVE 0.11+ WAY: Define custom configs first
      local configs = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim', 'require' } },
              workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) }
            }
          }
        },
        ruff = {
          settings = {
            ruff = { formatEnabled = true, format = { "I" } }
          },
          -- Note: Handlers/Keymaps are better handled via LspAttach autocmd,
          -- but keeping it here for your preference.
        },
        vtsls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git")(fname)
          end,
          single_file_support = false,
        }
      }

      -- THE LOOP: Register and Enable
      for _, server in ipairs(lsp_servers) do
        local config = configs[server] or {}
        config.capabilities = capabilities

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- GLOBAL KEYMAPS
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "LSP Definition" })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action" })
      vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP Format" })
    end
  },
}
