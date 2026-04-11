return function()
  -- Capabilities blink.cmp
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- Config globale pour tous les serveurs
  vim.lsp.config("*", { capabilities = capabilities })

  -- Configs spécifiques
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

  vim.lsp.config("eslint", {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  })

  -- Active les serveurs
  vim.lsp.enable({
    "stylua",
    "ts_ls",
    "html",
    "jsonls",
    "graphql",
    "lua_ls",
    "eslint",
    "cssls",
    "bashls",
  })

  -- Keymaps + highlights au LspAttach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        return
      end

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("lgd", vim.lsp.buf.definition, "Goto Definition")
      map("lgD", vim.lsp.buf.declaration, "Goto Declaration")
      map("<leader>lk", vim.lsp.buf.hover, "Hover Documentation")
      map("<leader>lD", vim.lsp.buf.type_definition, "Type Definition")
      map("<leader>cr", vim.lsp.buf.rename, "Rename")
      map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

      -- INFO: The following autocommand is used to enable inlay hints in your
      -- code, if the language server you are using supports them
      -- This may be unwanted, since they displace some of your code
      -- if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map("<leader>lth", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
      end

      --INFO: The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      -- if client.server_capabilities.documentHighlightProvider then
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = hl,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = hl,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  -- Diagnostics
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = "󰠠 ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  })
end
