return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    notify_on_error = false,

    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then return end
      return {
        timeout_ms = 2000,
        lsp_fallback = false, -- explicit formatters only; eslint format-on-save is handled by its LSP
      }
    end,

    default_format_opts = {
      stop_after_first = true,
    },

    formatters_by_ft = {
      lua = { "stylua" },
      -- biome-check = format + safe lint fixes + assists (organize imports).
      -- Runs only when biome.json exists (see condition below); falls back to prettierd
      javascript      = { "biome-check", "prettierd", "prettier" },
      typescript      = { "biome-check", "prettierd", "prettier" },
      javascriptreact = { "biome-check", "prettierd", "prettier" },
      typescriptreact = { "biome-check", "prettierd", "prettier" },
      json            = { "biome-check", "prettierd", "prettier" },
      jsonc           = { "biome-check", "prettierd" },
      -- prettierd handles everything biome doesn't cover
      html     = { "prettierd", "prettier" },
      css      = { "prettierd", "prettier" },
      scss     = { "prettierd", "prettier" },
      graphql  = { "prettierd", "prettier" },
      yaml     = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
    },

    formatters = {
      stylua = {
        env = { indent_type = "Spaces" },
      },
      -- biome-check only runs when biome.json / biome.jsonc is present in the project tree
      ["biome-check"] = {
        condition = function(_, ctx)
          return vim.fs.find(
            { "biome.json", "biome.jsonc" },
            { path = ctx.dirname, upward = true }
          )[1] ~= nil
        end,
      },
    },
  },
}
