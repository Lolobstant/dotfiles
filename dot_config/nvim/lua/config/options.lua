-- :help options
local options = {
  opt = {
    backup = false,                          -- creates a backup file
    autowrite = true,                        -- Auto write buffers
    confirm = true,                          -- Confirm to save changes before exiting modified buffer
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 0,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file
    fillchars = { eob = " " },               -- Disable `~` on nonexistent lines
    hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    infercase = true,                        -- Infer cases in keyword completion
    mouse = "a",                             -- allow the mouse to be used in neovim
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2,                         -- always show tabs
    smartcase = true,                        -- smart case

    -- Indenting
    smartindent = true,    -- make indenting smarter again
    copyindent = true,     -- Copy the previous indentation on autoindenting
    breakindent = true,    -- Wrap indent to match line start
    preserveindent = true, -- Preserve indent structure as much as possilbe
    expandtab = true,      -- convert tabs to spaces
    shiftwidth = 2,        -- the number of spaces inserted for each indentation
    --shiftrount = true,                       -- Round indenting

    -- Format
    formatoptions = "jcroqlnt", -- tcqj

    -- Grep
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg --hidden --vimgrep --smart-case --",

    -- Cmd
    inccommand = "nosplit", -- preview incremental substitute

    splitbelow = true,      -- force all horizontal splits to go below current window
    splitright = true,      -- force all vertical splits to go to the right of current window
    swapfile = false,       -- creates a swapfile
    termguicolors = true,   -- set term gui colors (most terminals support this)
    timeoutlen = 300,       -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,        -- enable persistent undo
    updatetime = 250,       -- faster completion (4000ms default)
    writebackup = false,    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    tabstop = 2,            -- insert 2 spaces for a tab
    cursorline = true,      -- highlight the current line

    -- Side line numbers
    number = true,         -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 2,       -- set number column width to 2 {default 4}

    signcolumn = "yes",    -- always show the sign column, otherwise it would shift the text each time
    wrap = true,           -- display lines as one long line
    linebreak = true,      -- companion to wrap, don't split words
    scrolloff = 8,         -- minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8,     -- minimal number of screen columns either side of cursor if wrap is `false`

    -- GUI
    guifont =
    "CartographCF Nerd Font:h-slight:h15, FiraCode Nerd Font:h-slight:h13, Iosevka Nerd Font, Menlo, Monaco, 'Courier New', monospace", -- the font used in graphical neovim applications
    list = true,                                                                                                                        -- show invisible char (tabs, spaces..)
    -- colorcolumn = "80",
    background = "dark",

    foldenable = true,   -- enable fold for nvim-ufo
    foldlevel = 99,      -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    foldcolumn = nil,    --vim.fn.has("nvim-0.9") == 1 and "1" or nil, -- show foldcolumn (depth of fold) in nvim 0.9
    -- foldmethod = "syntax",

    -- Status line
    laststatus = 3, -- Influences status line
  },
  g = {
    mapleader = " ",             -- set leader key
    maplocalleader = " ",
    highlighturl_enabled = true, -- highlight URLs by default
    autoformat_enabled = true,   -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
  },
  t = {},
}

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end

vim.opt.viewoptions:remove("curdir")             -- disable saving current directory with views
vim.opt.shortmess:append({ s = true, I = true }) -- disable startup message
vim.opt.backspace:append({ "nostop" })           -- Don't stop backspace at insert
vim.opt.whichwrap:append("bs<>[]hl")             -- which "horizontal" keys are allowed to travel to prev/next line
vim.opt.listchars:append("space: ")
-- vim.opt.listchars:append("space:⋅")

if vim.fn.has("nvim-0.9") == 1 then
  vim.opt.diffopt:append("linematch:60") -- enable linematch diff algorithm
end

local alpha = function()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
end

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- vim.opt.listchars:append "eol:↴"
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.o.background = "dark"
  -- vim.g.neovide_transparency = 0.95
  -- vim.g.transparency = 1
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end

-- vim.opt.listchars:append "space:⋅"
