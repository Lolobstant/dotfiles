return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Désactive les features LSP/treesitter auto sur les gros fichiers
    bigfile = { enabled = true },

    -- Remplace vim.notify() avec un rendu stylé
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "fancy",
    },

    -- Remplace vim.ui.input et vim.ui.select (rename LSP, sélections, etc.)
    input = { enabled = true },
  },
}
