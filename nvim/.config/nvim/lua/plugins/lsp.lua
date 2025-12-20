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
        ensure_installed = lsp_servers
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
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Setup all servers with default config
      for _, server in ipairs(lsp_servers) do
        lspconfig[server].setup({ capabilities = capabilities })
      end

      -- Override with custom configurations
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim', 'require' }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        }
      })

      lspconfig.ruff.setup({
        capabilities = capabilities,
        settings = {
          ruff = {
            formatEnabled = true,
            format = { "I" }
          }
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr })
        end,
      })

      lspconfig.vtsls.setup({
        capabilities = capabilities,
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(".git")(fname)
        end,
        single_file_support = false,
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}
