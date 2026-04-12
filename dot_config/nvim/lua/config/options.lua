-- => >=~~> <-> <=>
--@> $>
--$$ @@
-- 0 o O
-- :help options
local options = {
  opt = {
    backup = false, -- creates a backup file
    autoread = true, -- Auto read change on buffers
    autowrite = true, -- Auto write buffers
    confirm = true, -- Confirm to save changes before exiting modified buffer
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight = 0, -- more space in the neovim command line for displaying messages
    completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    fillchars = { eob = " " }, -- Disable `~` on nonexistent lines
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    infercase = true, -- Infer cases in keyword completion
    mouse = "a", -- allow the mouse to be used in neovim
    pumheight = 10, -- pop up menu height
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2, -- always show tabs
    smartcase = true, -- smart case

    -- Indenting
    smartindent = true, -- make indenting smarter again
    copyindent = true, -- Copy the previous indentation on autoindenting
    breakindent = true, -- Wrap indent to match line start
    preserveindent = true, -- Preserve indent structure as much as possilbe
    expandtab = true, -- convert tabs to spaces
    shiftwidth = 2, -- the number of spaces inserted for each indentation
    --shiftrount = true,                       -- Round indenting

    -- Format
    formatoptions = "jcroqlnt", -- tcqj

    -- Grep
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg --hidden --vimgrep --smart-case --",

    -- Cmd
    inccommand = "nosplit", -- preview incremental substitute

    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = true, -- creates a swapfile
    directory = vim.fn.stdpath("state") .. "/swap",
    termguicolors = true, -- set term gui colors (most terminals support this)
    timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true, -- enable persistent undo
    updatetime = 250, -- faster completion (4000ms default)
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    tabstop = 2, -- insert 2 spaces for a tab
    cursorline = true, -- highlight the current line

    -- Side line numbers
    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 2, -- set number column width to 2 {default 4}

    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    wrap = true, -- display lines as one long line
    linebreak = true, -- companion to wrap, don't split words
    scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`

    -- GUI
    -- guimont = "PragmataPro Mono Liga:h15",
    -- guifont = "CommitMono:h14",
    -- guifont = "CartographCF Nerd Font:h14",
    -- guifont = "FiraCode Nerd Font:h14",
    -- guifont = "JetBrainsMono Nerd Font:h14",
    -- guifont = "Iosevka Nerd Font:h15",
    -- "CartographCF Nerd Font:h-slight:h15, FiraCode Nerd Font:h-slight:h13, Iosevka Nerd Font, Menlo, Monaco, 'Courier New', monospace", -- the font used in graphical neovim applications
    list = true, -- show invisible char (tabs, spaces..)
    -- colorcolumn = "80",
    background = "light",

    foldenable = true, -- enable fold for nvim-ufo
    foldlevel = 99, -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    -- foldcolumn = nil, --vim.fn.has("nvim-0.9") == 1 and "1" or nil, -- show foldcolumn (depth of fold) in nvim 0.9
    -- foldmethod = "syntax",

    -- Status line
    -- 0 = no status line
    -- 1 = only with multiple windows
    -- 2 = always avery windows
    -- 3 = always one global line
    laststatus = 3,
  },
  g = {
    mapleader = " ", -- set leader key
    maplocalleader = " ",
    highlighturl_enabled = true, -- highlight URLs by default
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    loaded_perl_provider = 0,
    loaded_ruby_provider = 0,
    loaded_python3_provider = 0,
    loaded_node_provider = 0,
  },
  t = {},
}
-- Sync nvm PATH avec nvim (pour Mason et tous les child processes)
local nvm_dir = vim.fn.expand("~/.nvm/versions/node")
if vim.fn.isdirectory(nvm_dir) == 1 then
  local versions = vim.fn.glob(nvm_dir .. "/*/bin", false, true)
  if #versions > 0 then
    table.sort(versions)
    -- prend la plus haute version installée

    vim.env.PATH = "/opt/homebrew/bin:" .. versions[#versions] .. ":" .. vim.env.PATH
  end
end
for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end

-- local function apply_hl_overrides()
--   vim.api.nvim_set_hl(0, "Constant", { fg = "#ff5858" })
-- end
local function apply_hl_overrides()
  -- vim.cmd.colorscheme("patana")
  vim.api.nvim_set_hl(0, "Constant", { fg = "#ff5858" })
  -- neogit.hl.setup utilise default=true → skip les groupes "cleared" après colorscheme
  -- On force la définition directement, sans default=true, après tous les listeners
  -- vim.api.nvim_set_hl(0, "NeogitDiffAdd", { link = "DiffAdd" })
  -- vim.api.nvim_set_hl(0, "NeogitDiffDelete", { link = "DiffDelete" })
  -- vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { link = "DiffAdd" })
  -- vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { link = "DiffDelete" })
  -- vim.api.nvim_set_hl(0, "NeogitDiffContext", { link = "Normal" })
  -- vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { link = "CursorLine" })
  -- vim.api.nvim_set_hl(0, "NeogitHunkHeader", { link = "Folded" })
  -- vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { link = "Search" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_hl_overrides,
})
-- Pour le thème déjà chargé au démarrage
vim.schedule(apply_hl_overrides)

vim.opt.viewoptions:remove("curdir") -- disable saving current directory with views
vim.opt.shortmess:append({ s = true, I = true }) -- disable startup message
vim.opt.backspace:append({ "nostop" }) -- Don't stop backspace at insert
vim.opt.whichwrap:append("bs<>[]hl") -- which "horizontal" keys are allowed to travel to prev/next line
vim.opt.listchars:append({ tab = "-->", trail = "·", nbsp = "␣" })

-- require("vim._core.ui2").enable({
--   enable = true,
--   msg = {
--     targets = {
--       [""] = "msg",
--       empty = "cmd",
--       bufwrite = "msg",
--       confirm = "cmd",
--       emsg = "pager",
--       echo = "msg",
--       echomsg = "msg",
--       echoerr = "pager",
--       completion = "cmd",
--       list_cmd = "pager",
--       lua_error = "pager",
--       lua_print = "msg",
--       progress = "pager",
--       rpc_error = "pager",
--       quickfix = "msg",
--       search_cmd = "cmd",
--       search_count = "cmd",
--       shell_cmd = "pager",
--       shell_err = "pager",
--       shell_out = "pager",
--       shell_ret = "msg",
--       undo = "msg",
--       verbose = "pager",
--       wildlist = "cmd",
--       wmsg = "msg",
--       typed_cmd = "cmd",
--     },
--     cmd = {
--       height = 0.5,
--     },
--     dialog = {
--       height = 0.5,
--     },
--     msg = {
--       height = 0.3,
--       timeout = 5000,
--     },
--     pager = {
--       height = 0.5,
--     },
--   },
-- })

vim.opt.diffopt:append("linematch:60")

local alpha = function()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
end

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- vim.opt.listchars:append "eol:↴"
  vim.g.neovide_input_macos_option_key_is_meta = true
  vim.o.background = options.opt.background
  -- vim.g.neovide_transparency = 0.95
  -- vim.g.transparency = 1
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end

-- vim.opt.listchars:append "space:⋅"
