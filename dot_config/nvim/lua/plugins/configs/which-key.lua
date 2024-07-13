return {
  --icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
  preset = "modern",
  disable = { filetypes = { "TelescopePrompt" } },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "  ", -- symbol used between a key and it's label
    group = "", --[[ "+",       -- symbol prepended to a group ]]
  },
  -- window = {
  --   border = "none", -- none/single/double/shadow
  -- },
}
