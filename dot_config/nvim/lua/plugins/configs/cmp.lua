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

return function()
  -- See `:help cmp`
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  -- load friendly snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  luasnip.config.setup({})

  cmp.setup({
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    -- selected_item_bg = "colored", -- colored / simple
    experimental = { ghost_text = true },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
      completion = {
        -- side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
        border = border("CmpDocBorder"),
        winhighlight = "Normal:CmpPmenu,Search:None",
        scrollbar = false,
      },
      documentation = {
        border = border("CmpDocBorder"),
        winhighlight = "Normal:CmpDoc",
      },
    },
    -- enable luasnip to handle snippet expansion for nvim_cmp
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = { completeopt = "menu,menuone,noinsert" },
    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 750, keyword_length = 2 },
      { name = "buffer", priority = 500, keyword_length = 3 },
      { name = "path", priority = 250 },
      { name = "render-markdown" },
    },

    -- For an understanding of why these mappings were
    -- chosen, you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    mapping = cmp.mapping.preset.insert({
      -- Select the [n]ext item
      ["<C-n>"] = cmp.mapping.select_next_item(),
      -- Select the [p]revious item
      ["<C-p>"] = cmp.mapping.select_prev_item(),

      -- Scroll the documentation window [b]ack / [f]orward
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),

      -- Accept ([y]es) the completion.
      --  This will auto-import if your LSP supports it.
      --  This will expand snippets if the LSP sent a snippet.
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),

      -- If you prefer more traditional completion keymaps,
      -- you can uncomment the following lines
      --['<CR>'] = cmp.mapping.confirm { select = true },
      --['<Tab>'] = cmp.mapping.select_next_item(),
      --['<S-Tab>'] = cmp.mapping.select_prev_item(),

      -- Manually trigger a completion from nvim-cmp.
      --  Generally you don't need this, because nvim-cmp will display
      --  completions whenever it has completion options available.
      ["<C-Space>"] = cmp.mapping.complete({}),

      -- `Enter` key to confirm completion
      ["<CR>"] = cmp.mapping.confirm({ select = false }),

      -- Think of <c-l> as moving to the right of your snippet expansion.
      --  So if you have a snippet that's like:
      --  function $name($args)
      --    $body
      --  end
      --
      -- <c-l> will move you to the right of each of the expansion locations.
      -- <c-h> is similar, except moving you backwards.
      ["<C-l>"] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { "i", "s" }),

      -- Navigate between snippet placeholder
      --       ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      --       ['<C-b>'] = cmp_action.luasnip_jump_backward(),

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    }),
  })
end
