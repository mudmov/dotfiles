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
          "pyright",
          "sqlls",
          "ltex",
          "yamlls"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.ansiblels.setup({})
      lspconfig.bashls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.html.setup({})
      lspconfig.eslint.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.grammarly.setup({})
      lspconfig.nginx_language_server.setup({})
      lspconfig.ruff.setup({})
      lspconfig.sqlls.setup({})
      lspconfig.ltex.setup({})
      lspconfig.yamlls.setup({})
      lspconfig.pyright.setup({})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}
