return function()
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.config("*", { capabilities = capabilities })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        completion = { callSnippet = "Replace" },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })

  -- vtsls replaces ts_ls — drop-in, works for all TS/JS projects.
  -- Image requires: npm install -g @vtsls/language-server
  vim.lsp.config("vtsls", {
    root_markers = { "pnpm-workspace.yaml", "tsconfig.json", "package.json", ".git" },
    settings = {
      typescript = {
        format = { enable = false }, -- biome or prettierd owns formatting
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
      },
      javascript = {
        format = { enable = false },
      },
      vtsls = {
        autoUseWorkspaceTsdk = true,
        enableMoveToFileCodeAction = true,
        tsserver = { maxTsServerMemory = 4096 },
        experimental = {
          completion = { enableServerSideFuzzyMatch = true },
        },
      },
    },
  })

  -- eslint: only attaches when .eslintrc* / eslint.config.* is found.
  -- Format-on-save via eslint LSP for ESLint projects (conform handles biome projects).
  vim.lsp.config("eslint", {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ name = "eslint", async = false })
        end,
      })
    end,
  })

  -- Mason bin en PATH — requis pour que vim.lsp.enable() trouve les serveurs Mason
  vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

  -- Enable all servers — each auto-detects its config file and only attaches when relevant:
  --   biome: requires biome.json or biome.jsonc
  --   eslint: requires .eslintrc* or eslint.config.*
  --   graphql: requires .graphqlrc* or graphql.config.*
  -- Image requires: npm install -g @vtsls/language-server vscode-langservers-extracted
  --                 bash-language-server
  vim.lsp.enable({
    "lua_ls",
    "vtsls",
    "biome",
    "eslint",
    "graphql",
    "bashls",
    "jsonls",
    "cssls",
    "html",
  })

  -- Buffer-local go-to keymaps (only active when LSP is attached)
  -- Global LSP actions (<leader>cr, <leader>ca, <leader>l*) are in config/mappings.lua
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      local builtin = require("telescope.builtin")
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("gd", builtin.lsp_definitions, "Go to Definition")
      map("gD", vim.lsp.buf.declaration, "Go to Declaration")
      map("gI", builtin.lsp_implementations, "Go to Implementation")
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map("<leader>lth", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "Toggle Inlay Hints")
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  -- Diagnostic display config (virtual_text, signs, float) is in config/diagnostics.lua
end
