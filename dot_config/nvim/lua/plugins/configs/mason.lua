return function()
  -- import mason
  local mason = require("mason")

  -- import mason-lspconfig
  -- local mason_lspconfig = require("mason-lspconfig")

  local mason_tool_installer = require("mason-tool-installer")

  -- enable mason and configure icons
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  mason_tool_installer.setup({
    auto_update = true,
    ensure_installed = {
      "stylua", -- Used to format Lua code
      "typescript-language-server",
      "jsonls",
      "graphql",
      "lua_ls",
      "biome",
      "bashls",
      "prettierd",
      "eslint-lsp",
      "js-debug-adapter",
    },
  })
end
