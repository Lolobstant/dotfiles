return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    notify_on_error = false,

    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return
      end
      return {
        timeout_ms = 2000,
        lsp_fallback = true,
      }
    end,

    default_format_opts = {
      stop_after_first = true,
    },

    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", "biome" },
      typescript = { "prettierd", "prettier", "biome" },
      javascriptreact = { "prettierd", "prettier", "biome" },
      typescriptreact = { "prettierd", "prettier", "biome" },
      html = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      scss = { "prettierd", "prettier" },
      json = { "prettierd", "prettier", "biome" },
      jsonc = { "prettierd", "prettier", "biome" },
      yaml = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      graphql = { "prettierd", "prettier" },
    },

    formatters = {
      stylua = {
        env = {
          indent_type = "Spaces",
        },
      },
    },
  },
}
