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
        ensure_installed = {
          "lua_ls",
          "ansiblels",
          "bashls",
          "dockerls",
          "html",
          "eslint",
          "jsonls",
          "grammarly",
          "nginx_language_server",
          "ruff",
          "sqlls",
          "ltex",
          "yamlls"
        }
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
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {'vim', 'require'}  -- Tell the language server that 'vim' is a global
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        }
      })
      lspconfig.ansiblels.setup({})
      lspconfig.bashls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.html.setup({})
      lspconfig.eslint.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.grammarly.setup({})
      lspconfig.nginx_language_server.setup({})
      lspconfig.ruff.setup({
        settings = {
          ruff = {
            formatEnabled = true,
            format = { "I" }  -- Additional formatting rules, if needed.
          }
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr })
        end,
      })
      lspconfig.sqlls.setup({})
      lspconfig.ltex.setup({})
      lspconfig.yamlls.setup({})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}


