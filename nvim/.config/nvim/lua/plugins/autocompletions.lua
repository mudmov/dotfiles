return {
  "saghen/blink.cmp",
  version = '1.*',
  opts = {
    sources = {
      -- add lazydev to your completion providers
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
    keymap = {
      preset = "default",  -- start with default mappings
      ["<Tab>"] = { "accept", "fallback" },   -- confirm selection or insert tab if no menu
      ["<S-Tab>"] = { "select_prev", "fallback" }, -- move back or insert shift+tab
    },
  },
}
