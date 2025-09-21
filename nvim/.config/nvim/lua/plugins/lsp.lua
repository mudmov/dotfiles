local lsp_servers = {
  "lua_ls",
  "bashls",
  "dockerls",
  "eslint",
  "jsonls",
  "ruff",
  "pyright",
  "yamlls",
  "ts_ls",
}

local linters_formatters = {
  "eslint_d",
  "prettier"
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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = linters_formatters
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
              globals = {'vim', 'require'}
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

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}
