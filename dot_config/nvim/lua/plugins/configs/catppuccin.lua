return {
  term_colors = true,
  background = {
    dark = "mocha",
  },
  dim_inactive = {
    enabled = true,    -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  styles = {
    conditionals = { "italic" },
    comments = { "italic" },
    variables = { "italic" },
  },
  integrations = {
    -- aerial = true,
    alpha = true,
    cmp = true,
    -- dashboard = true,
    -- flash = true,
    gitsigns = true,
    -- headlines = true,
    illuminate = true,
    indent_blankline = { enabled = true },
    -- leap = true,
    lsp_trouble = true,
    mason = true,
    markdown = true,
    mini = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    -- navic = { enabled = true, custom_bg = "lualine" },
    -- neotest = true,
    -- neotree = true,
    noice = true,
    notify = true,
    semantic_tokens = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
  },
}
