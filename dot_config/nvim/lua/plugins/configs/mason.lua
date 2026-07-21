return function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
  -- LSP servers come from the image. Mason manages only the DAP adapter
  -- because js-debug-adapter is not a simple npm global (Mason unpacks it correctly).
  require("mason-tool-installer").setup({
    auto_update = false,
    ensure_installed = {
      -- LSP servers (à migrer dans l'image au fil du temps)
      "vtsls",
      "lua-language-server",
      "bash-language-server",
      "graphql-language-service-cli",
      -- Formatters
      "biome",
      "prettierd",
      "stylua",
      -- DAP
      "js-debug-adapter",
    },
  })
end
