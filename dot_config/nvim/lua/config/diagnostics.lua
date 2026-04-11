-- Diagnostics config
vim.diagnostic.config({
  -- virtual_text = false,
  virtual_text = {
    prefix = "●", -- Could be '●', '▎', 'x'
    source = "if_many",
    severity = vim.diagnostic.severity.ERROR,
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
  underline = {
    severity = vim.diagnostic.severity.ERROR,
  },
})

-- Diagnostics change the sign simbol in the gutter
-- "󰠠 "
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})
