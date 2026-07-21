return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Mason: UI + js-debug-adapter (DAP). LSP binaries come from the image.
    {
      "williamboman/mason.nvim",
      dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      config = require("plugins.configs.mason"),
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    { "j-hui/fidget.nvim", opts = {} },
    "saghen/blink.cmp",
  },
  config = require("plugins.configs.lsp"),
}
