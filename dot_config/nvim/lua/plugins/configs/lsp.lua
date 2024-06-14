local utils = require("utils")

return function()
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end
      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
          end,
        })
      end

      -- The following autocommand is used to enable inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map("<leader>lth", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "LSP: [T]oggle Inlay [H]ints")
      end
    end,
  })

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`tsserver`) will work just fine
    -- tsserver = {},
    --
    tsserver = {},
    html = {},
    jsonls = {},
    graphql = {},

    biome = {},
    lua_ls = {
      -- cmd = {...},
      -- filetypes = { ...},
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
  }

  -- Ensure the servers and tools above are installed
  --  To check the current status of installed tools and/or manually install
  --  other tools, you can run
  --    :Mason
  --
  --  You can press `g?` for help in this menu.
  require("mason").setup()

  -- You can add other tools here that you want Mason to install
  -- for you, so that they are available from within Neovim.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    "stylua", -- Used to format Lua code
    "tsserver",
    "html",
    "jsonls",
    "graphql",
    "lua_ls",
    -- "eslint",
    "biome",
    "bashls",
  })
  require("mason-tool-installer").setup({ ensure_installed = ensure_installed, auto_update = true })

  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        print("mason-lspconfig")
        local server = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
      end,
    },
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MasonToolsStartingInstall",
    group = vim.api.nvim_create_augroup("mason_auto_update_start", { clear = true }),
    callback = function()
      vim.schedule(function()
        pcall(vim.cmd, "MsonToolsUpdate")
        vim.notify("mason-tool-installer is starting")
      end)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("mason_auto_update", { clear = true }),
    pattern = "MasonToolsUpdateCompleted",
    callback = function(e)
      vim.schedule(function()
        -- check if table not empty to notify

        if next(e.data) then
          vim.notify(vim.inspect(e.data), vim.log.levels.INFO) -- print the table that lists the programs that were installed
        end
      end)
    end,
  })
end

-- function()
--   local lsp = require('lsp-zero').preset({
--     manage_nvim_cmp = {
--       set_extra_mappings = true
--     }
--   })
--   lsp.nvim_workspace()
--   local lspformat = require('lsp-format')
--   require('neodev').setup {}
--
--   lsp.on_attach(function(client, bufnr)
--     local opts = { buffer = bufnr }
--     lsp.default_keymaps(opts)
--
--     -- make sure you use clients with formatting capabilities
--     -- otherwise you'll get a warning message
--     if client.supports_method('textDocument/formatting') then
--       lspformat.on_attach(client)
--     end
--   end)
--
--   -- NOTE: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
--   -- lsp.ensure_installed({
--   --   'tsserver', 'html', 'jsonls', 'graphql', 'lua_ls', 'eslint', 'bashls',
--   -- })
--   local servers = {
--     'tsserver', 'html', 'jsonls', 'graphql', 'lua_ls', 'eslint', 'bashls',
--   }
--   require('mason').setup({})
--   require('mason-tool-installer').setup { ensure_installed = servers, auto_update = true }
--   require('mason-lspconfig').setup({
--     automatic_installation = true,
--     ensure_installed = servers,
--     handlers = {
--       lsp.default_setup,
--     },
--   })
--   vim.api.nvim_create_autocmd('User', {
--     pattern = 'MasonToolsStartingInstall',
--     group = vim.api.nvim_create_augroup('mason_auto_update_start', { clear = true }),
--     callback = function()
--       vim.schedule(function()
--         vim.notify('mason-tool-installer is starting')
--       end)
--     end,
--   })
--   vim.api.nvim_create_autocmd('User', {
--     group = vim.api.nvim_create_augroup('mason_auto_update', { clear = true }),
--     pattern = 'MasonToolsUpdateCompleted',
--     callback = function(e)
--       vim.schedule(function()
--         vim.notify(vim.inspect(e.data), vim.log.levels.INFO) -- print the table that lists the programs that were installed
--       end)
--     end,
--   })
--   -- (Optional) Configure lua language server for neovim
--   local lspconfig = require('lspconfig')
--   local prettier = { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true }
--
--   lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
--   lspconfig.efm.setup({
--     on_attach = lspformat.on_attach,
--     init_options = { documentFormatting = true },
--     settings = {
--       rootMarkers = { ".git/" },
--       languages = {
--         javascript = { prettier },
--         html = { prettier },
--         json = { prettier },
--         graphql = { prettier },
--       }
--     }
--   })
--
--   lsp.set_server_config({
--     capabilities = {
--       textDocument = {
--         foldingRange = {
--           dynamicRegistration = false,
--           lineFoldingOnly = true
--         }
--       }
--     }
--   })
--
--   lsp.setup()
--
--   local cmp = require('cmp')
--   local cmp_action = require('lsp-zero').cmp_action()
--   local luasnip = require 'luasnip'
--
--   require('luasnip.loaders.from_vscode').lazy_load()
--
--   luasnip.config.setup {}
--
--   local function border(hl_name)
--     return {
--       { "╭", hl_name },
--       { "─", hl_name },
--       { "╮", hl_name },
--       { "│", hl_name },
--       { "╯", hl_name },
--       { "─", hl_name },
--       { "╰", hl_name },
--       { "│", hl_name },
--     }
--   end
--
--   cmp.setup({
--     -- icons = true,
--     -- lspkind_text = true,
--     -- style = "default",            -- default/flat_light/flat_dark/atom/atom_colored
--     -- border_color = "grey_fg",     -- only applicable for "default" style, use color names from base30 variables
--     -- selected_item_bg = "colored", -- colored / simple
--     window = {
--       -- completion = cmp.config.window.bordered(),
--       -- documentation = cmp.config.window.bordered(),
--       completion = {
--         -- side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
--         border = border "CmpDocBorder",
--         winhighlight = "Normal:CmpPmenu,Search:None",
--         scrollbar = false,
--       },
--       documentation = {
--         border = border "CmpDocBorder",
--         winhighlight = "Normal:CmpDoc",
--       },
--     },
--     snippet = {
--       expand = function(args)
--         luasnip.lsp_expand(args.body)
--       end,
--     },
--     sources = {
--       { name = 'nvim_lsp', priority = 1000 },
--       { name = 'luasnip',  priority = 750, keyword_length = 2 },
--       { name = 'buffer',   priority = 500, keyword_length = 3 },
--       { name = 'path',     priority = 250 },
--     },
--     mapping = {
--       -- `Enter` key to confirm completion
--       ['<CR>'] = cmp.mapping.confirm({ select = false }),
--
--       -- Ctrl+Space to trigger completion menu
--       ['<C-Space>'] = cmp.mapping.complete(),
--
--       -- Navigate between snippet placeholder
--       ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--       ['<C-b>'] = cmp_action.luasnip_jump_backward(),
--     }
--   })
-- end
