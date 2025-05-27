local utils = require("utils")

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- ts_ls = {},
  html = {},
  jsonls = {},
  graphql = {},
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
-- Create an augroup that is used for managing our formatting autocmds.
--      We need one augroup per client to make sure that multiple clients
--      can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = "lsp-format-" .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

local on_attach = function(_, bufnr)
  local nmap = function(keymap, cmd, desc)
    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
    if utils.is_available("which-key.nvim") then
      local wk = require("which-key")
      wk.register({
        [keymap] = { cmd, desc, noremap = true, silent = true, buffer = bufnr },
      })
    else
      vim.keymap.set("n", keymap, cmd, bufopts)
    end
  end

  nmap("lgd", vim.lsp.buf.definition, "[L]SP [G]oto [D]efinition")
  nmap("lgD", vim.lsp.buf.declaration, "[L]SP [G]oto [D]eclaration")
  nmap("lgI", vim.lsp.buf.implementation, "[L]SP [G]oto [I]mplementation")
  nmap("<leader>lk", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>lD", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>Wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>Wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>Wl", function()
    -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  -- nmap('lr', vim.lsp.buf.rename, bufopts)
  -- nmap('<space>lf', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- if client.supports_method("textDocument/formatting") then
  --   vim.api.nvim_clear_autocmds({ group = get_augroup(client), buffer = bufnr })
  --   vim.cmd("autocmd BufWritePre lua vim.lsp.buf.format()")
  -- end
  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   print "add Format user command"
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
end

local on_lsp_attach = function(args)
  -- print 'on_lsp_attach'
  local client_id = args.data.client_id
  local client = vim.lsp.get_client_by_id(client_id)
  local bufnr = args.buf

  -- Only attach to clients that support document formatting
  if not client.server_capabilities.documentFormattingProvider then
    vim.notify("[on_lsp_attach]no document formatting provider")
    return
  end

  -- ts_ls usually works poorly. Sorry you work with bad languages
  -- You can remove this line if you know what you're doing :)
  -- if client.name == 'ts_ls' then
  --   return
  -- end

  -- Create an autocmd that will run *before* we save the buffer.
  --  Run the formatting command for the LSP that has just attached.
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = get_augroup(client),
    buffer = bufnr,
    callback = function()
      -- if not format_is_enabled then
      --   return
      -- end

      vim.lsp.buf.format({
        async = false,
        filter = function(c)
          return c.id == client.id
        end,
      })
    end,
  })
end

return function()
  local mason_lspconfig = require("mason-lspconfig")

  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
  })
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if not status_cmp_ok then
    vim.notify("[mason-lsp] cmp_nvim_lsp not available")
    return
  end
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

  mason_lspconfig.setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      })
    end,
  })
  --NOTE: setup formatting
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
    callback = on_lsp_attach,
  })
end
