return function()
  local lsp = require('lsp-zero').preset({
    manage_nvim_cmp = {
      set_extra_mappings = true
    }
  })
  lsp.nvim_workspace()
  local lspformat = require('lsp-format')
  require('neodev').setup {}

  lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }
    lsp.default_keymaps(opts)

    -- make sure you use clients with formatting capabilities
    -- otherwise you'll get a warning message
    if client.supports_method('textDocument/formatting') then
      lspformat.on_attach(client)
    end
  end)

  -- NOTE: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
  -- lsp.ensure_installed({
  --   'tsserver', 'html', 'jsonls', 'graphql', 'lua_ls', 'eslint', 'bashls',
  -- })
  local servers = {
    'tsserver', 'html', 'jsonls', 'graphql', 'lua_ls', 'eslint', 'bashls',
  }
  require('mason').setup({})
  require('mason-tool-installer').setup { ensure_installed = servers, auto_update = true }
  require('mason-lspconfig').setup({
    automatic_installation = true,
    ensure_installed = servers,
    handlers = {
      lsp.default_setup,
    },
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsStartingInstall',
    group = vim.api.nvim_create_augroup('mason_auto_update_start', { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.notify('mason-tool-installer is starting')
      end)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('mason_auto_update', { clear = true }),
    pattern = 'MasonToolsUpdateCompleted',
    callback = function(e)
      vim.schedule(function()
        vim.notify(vim.inspect(e.data), vim.log.levels.INFO) -- print the table that lists the programs that were installed
      end)
    end,
  })
  -- (Optional) Configure lua language server for neovim
  local lspconfig = require('lspconfig')
  local prettier = { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true }

  lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
  lspconfig.efm.setup({
    on_attach = lspformat.on_attach,
    init_options = { documentFormatting = true },
    settings = {
      rootMarkers = { ".git/" },
      languages = {
        javascript = { prettier },
        html = { prettier },
        json = { prettier },
        graphql = { prettier },
      }
    }
  })

  lsp.set_server_config({
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }
      }
    }
  })

  lsp.setup()

  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local luasnip = require 'luasnip'

  require('luasnip.loaders.from_vscode').lazy_load()

  luasnip.config.setup {}

  local function border(hl_name)
    return {
      { "╭", hl_name },
      { "─", hl_name },
      { "╮", hl_name },
      { "│", hl_name },
      { "╯", hl_name },
      { "─", hl_name },
      { "╰", hl_name },
      { "│", hl_name },
    }
  end

  cmp.setup({
    -- icons = true,
    -- lspkind_text = true,
    -- style = "default",            -- default/flat_light/flat_dark/atom/atom_colored
    -- border_color = "grey_fg",     -- only applicable for "default" style, use color names from base30 variables
    -- selected_item_bg = "colored", -- colored / simple
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
      completion = {
        -- side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
        border = border "CmpDocBorder",
        winhighlight = "Normal:CmpPmenu,Search:None",
        scrollbar = false,
      },
      documentation = {
        border = border "CmpDocBorder",
        winhighlight = "Normal:CmpDoc",
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp', priority = 1000 },
      { name = 'luasnip',  priority = 750, keyword_length = 2 },
      { name = 'buffer',   priority = 500, keyword_length = 3 },
      { name = 'path',     priority = 250 },
    },
    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = false }),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      -- Navigate between snippet placeholder
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }
  })
end
