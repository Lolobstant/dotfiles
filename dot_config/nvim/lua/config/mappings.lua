local lazy = require("lazy")

local utils = require("utils")
local is_available = utils.is_available

local M = {
  n = {},
  i = {},
  v = {},
  t = {},
}

-- local sections = {
--   bs = { desc = "󰒺 Sort Buffers" },
--   d = { desc = "󰯉 Debugger" },
-- terminal 
-- AI 
-- }

if is_available("which-key.nvim") then
  local wk = require("which-key")
  wk.add({
    { "<leader>b", group = "Buffers", icon = "󰓩" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "DAP/Diag", icon = "󰓙" },
    { "<leader>g", group = "Git", icon = "" },
    { "<leader>gw", group = "Worktree", icon = "" },
    { "<leader>l", group = "LSP", icon = "󱧤" },
    { "<leader>p", group = "Packages", icon = "󰏖" },
    { "<leader>s", group = "Search" },
    { "<leader>S", group = "Session" },
    { "<leader>t", group = "Terminal", icon = "" },
    -- ['<leader>f'] = {group ="Files" },
    { "<leader>u", group = "UI", icon = "󰺾" },
    { "<leader>un", group = "Notifications", icon = "󰎟" },
    { "<leader>w", group = "Window", icon = "" },
    { "<leader>W", group = "Workspace", icon = "" },
  })
end

local function applyMapping(table)
  local keys = require("lazy.core.handler").handlers.keys
  for mode, maps in pairs(table) do
    for keymap, options in pairs(maps) do
      local cmd = options[1]
      local opts = type(options[2]) == "string" and { desc = options[2] } or options[2]
      if not keys.active[keys.parse({ lhs = keymap, mode = mode }).id] then
        if is_available("which-key.nvim") then
          local wk = require("which-key")
          -- print(utils.dump(vim.tbl_extend("keep", { cmd, }, opts)))
          -- local keymapOpts = { cmd, opts.desc, noremap = false }
          -- for v, k in pairs(opts) do
          --   keymapOpts[k] = v
          -- end
          wk.add({
            { keymap, cmd, desc = opts.desc, noremap = false, mode = mode },
          })
        else
          vim.keymap.set(mode, keymap, cmd, opts)
        end
      else
        vim.notify("Key already exists for: %s, %s, %s", mode, keymap)
      end
    end
  end
end

-- INFO: Splits
if is_available("smart-splits.nvim") then
  local ss = require("smart-splits")

  M.n["<C-h>"] = { ss.move_cursor_left, "Move to left split" }
  M.n["<C-j>"] = { ss.move_cursor_down, "Move to below split" }
  M.n["<C-k>"] = { ss.move_cursor_up, "Move to above split" }
  M.n["<C-l>"] = { ss.move_cursor_right, "Move to right split" }

  M.n["<M-left>"] = { ss.resize_left, "Resize split left" }
  M.n["<M-down>"] = { ss.resize_down, "Resize split down" }
  M.n["<M-up>"] = { ss.resize_up, "Resize split up" }
  M.n["<M-right>"] = { ss.resize_right, "Resize split right" }

  -- INFO: swap splits
  M.n["<C-tab>"] = { ss.swap_buf_right, "Move split right" }
  M.n["<C-S-tab>"] = { ss.swap_buf_left, "Move split right" }
else
  -- INFO: Move arround splits
  M.n["<C-h>"] = { "<C-w>h", "Move to LEFT split" }
  M.n["<C-l>"] = { "<C-w>l", "Move to RIGHT split" }
  M.n["<C-j>"] = { "<C-w>j", "Move to DOWN split" }
  M.n["<C-k>"] = { "<C-w>k", "Move to UP split" }

  -- INFO: Resize splits
  M.n["<M-up>"] = { "<cmd>resize -2<cr>", "Resize Split Up" }
  M.n["<M-down>"] = { "<cmd>resize +2<cr>", "Resize Split Down" }
  M.n["<M-left>"] = { "<cmd>vertical resize -2<cr>", "Resize Split Left" }
  M.n["<M-right>"] = { "<cmd>vertical resize +2<cr>", "Resize Split Right" }
end
M.n["<leader>|"] = { "<cmd>vsplit<cr>", "Split verticaly" }
M.n["<leader>-"] = { "<cmd>split<cr>", "Split horizontaly" }

-- INFO: NeoTree
-- if is_available("neo-tree.nvim") then
-- M.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", "Toggle Explorer" }
-- M.n["<leader>o"] = {
-- function()
-- if vim.bo.filetype == "neo-tree" then
-- vim.cmd.wincmd("p")
-- else
-- vim.cmd.Neotree("focus")
-- end
-- end,
-- "Toggle Explorer Focus",
-- }
-- end

-- INFO: Telescope
if is_available("telescope.nvim") then
  local builtin = require("telescope.builtin")
  local extensions = require("telescope").extensions
  -- local git_worktree = require("git-worktree");
  M.n["<leader>sr"] = { builtin.oldfiles, "[S]earch [R]ecently opened files" }
  M.n["<leader><space>"] = { builtin.buffers, "Find existing buffers" }
  M.n["<leader>/"] = {
    function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
    end,
    "Fuzzily search in current buffer",
  }
  -- INFO: Git
  -- M.n["<leader>gf"] = { builtin.git_files, "Search [G]it [F]iles" }
  M.n["<leader>gs"] = { builtin.git_status, "Search [G]it [S]tatus" }
  M.n["<leader>gb"] = { builtin.git_branches, "[G]it [B]ranches" }

  if is_available("neogit") then
    local neogit = require("neogit")
    M.n["<leader>gs"] = { neogit.open, "[G]it [S]tatus" }
    M.n["<leader>gS"] = {
      function()
        neogit.open({ kind = "floating" })
      end,
      "[G]it [S]tatus Floating",
    }
    -- M.n["<leader>gd"] = { neogit.git_diff, "[G]it [D]iff" }
    -- M.n["<leader>gb"] = {
    --   function()
    --     neogit.git_blame({})
    --   end,
    --   "[G]it [B]lame",
    -- }
    -- M.n["<leader>gl"] = { neogit.git_graph, "[G]it [L]og" }
  end
  if is_available("diffview.nvim") then
    -- local diffview = require("diffview")
    M.n["<leader>gD"] = { "<cmd>DiffviewOpen<cr>", "[G]it [D]iff All" }
    M.n["<leader>gl"] = { "<cmd>DiffviewFileHistory<cr>", "[G]it [L]og" }
  end

  if is_available("gitsigns.nvim") then
    local gitsigns = require("gitsigns")
    M.n["<leader>gd"] = { gitsigns.diffthis, "[G]it [D]iff This" }
    M.n["<leader>gp"] = { gitsigns.preview_hunk, "[G]it [P]review Hunk" }
    M.n["<leader>hn"] = {
      function()
        gitsigns.nav_hunk("next")
      end,
      "[H]unk [N]ext",
    }
    M.n["<leader>hp"] = {
      function()
        gitsigns.nav_hunk("prev")
      end,
      "[H]unk [P]revious",
    }
  end

  if is_available("fugit2.nvim") then
    local fugit2 = require("fugit2")
    M.n["<leader>gs"] = { fugit2.git_status, "[G]it [S]tatus" }
    M.n["<leader>gd"] = { fugit2.git_diff, "[G]it [D]iff" }
    M.n["<leader>gb"] = {
      function()
        fugit2.git_blame({})
      end,
      "[G]it [B]lame",
    }
    M.n["<leader>gl"] = { fugit2.git_graph, "[G]it [L]og" }
  end
  -- if is_available("lazygit.nvim") then
  --   -- local lazygit = require("lazygit")
  --   M.n["<leader>gs"] = { "<cmd>LazyGit<cr>", "[G]it [S]tatus" }
  -- end

  -- if is_available("nvim-tinygit") then
  --   local tinygit = require("tinygit")
  --   -- M.n["<leader>"]vim.keymap.set("n", "ga", "<cmd>Gitsigns add_hunk<CR>") -- gitsigns.nvim
  --   M.n["<leader>gs"] = { tinygit.interactiveStaging, "[G]it [S]tage" }
  --   M.n["<leader>gu"] = { tinygit.undoLastCommit, "[G]it [U]ndo last commit" }
  --   M.n["<leader>gc"] = {
  --     function()
  --       tinygit.smartCommit({ pullBeforePush = true })
  --     end,
  --     "[G]it [C]ommit",
  --   }
  --   M.n["<leader>gp"] = {
  --     function()
  --       tinygit.push({ pullBeforePush = true })
  --     end,
  --     "[G]it [P]ush",
  --   }
  --   M.n["<leader>ga"] = {
  --     function()
  --       tinygit.amendOnlyMsg({ forcePushIfDiverged = false })
  --     end,
  --     "[G]it [A]mend commit message",
  --   }
  -- end

  -- INFO: Git-worktree
  M.n["<leader>gwl"] = { extensions.git_worktree.git_worktrees, "[G]it [W]orktree [L]ist" }
  M.n["<leader>gwc"] = { extensions.git_worktree.create_git_worktree, "[G]it [W]orktree [C]reate" }
  -- M.n['<leader>gc'] = {builtin.git_commits, 'Search [G]it [C]ommits'}
  -- M.n['<leader>gb'] = {builtin.git_branches, 'Search [G]it [B]ranches'}

  -- INFO: Search git files in git repo or fall back to find_files
  -- We cache the results of "git rev-parse"
  -- Process creation is expensive in Windows, so this reduces latency
  -- local is_inside_work_tree = {}
  M.n["<leader>sf"] = {
    function()
      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
      end
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end
      local opts = {}
      if is_git_repo() then
        opts = {
          cwd = get_git_root(),
        }
      end
      require("telescope.builtin").find_files(opts)
    end --[[ function()
      local opts = { hidden = true, show_untracked = true } -- define here if you want to define something

      local cwd = vim.fn.getcwd()
      if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
      end

      if is_inside_work_tree[cwd] then
        builtin.git_files(opts)
      else
        builtin.find_files(opts)
      end
    end ]],
    "[S]earch [F]iles",
  }
  M.n["<leader>sh"] = { builtin.help_tags, "[S]earch [H]elp" }
  M.n["<leader>sw"] = { builtin.grep_string, "[S]earch [W]ord" }
  M.n["<leader>sg"] = { builtin.live_grep, "[S]earch by [G]rep" }
  M.n["<leader>sd"] = { builtin.diagnostics, "[S]earch [D]iagnostics" }
  M.n["<leader>sM"] = { builtin.man_pages, "[S]earch [M]an Pages" }
  M.n["<leader>sk"] = { builtin.keymaps, "[S]earch [K]eymaps" }

  --INFO: LSP:
  -- M.n["gd"] = { builtin.lsp_definitions, "LSP: [G]oto [D]efinition" }
  -- M.n["gD"] = { vim.lsp.buf.declaration, "LSP: [G]oto [D]eclaration" }
  -- M.n["gr"] = { builtin.lsp_references, "LSP: [G]oto [R]eferences" }
  -- M.n["gI"] = { builtin.lsp_implementations, "LSP: [G]oto [I]mplementation" }
  M.n["<leader>lD"] = { builtin.lsp_type_definitions, "LSP: Type [D]efinition" }
  M.n["<leader>lds"] = { builtin.lsp_document_symbols, "LSP: [D]ocument [S]ymbols" }
  M.n["<leader>lws"] = { builtin.lsp_dynamic_workspace_symbols, "LSP: [W]orkspace [S]ymbols" }
  M.n["<leader>cr"] = { vim.lsp.buf.rename, "LSP: [C]ode [R]ename" }
  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  M.n["<leader>ca"] = { vim.lsp.buf.code_action, "LSP: [C]ode [A]ction" }
  M.n["<leader>cd"] = { vim.lsp.buf.hover, "LSP: [C]ode hover [D]ocumentation" }

  if is_available("huez.nvim") then
    local pickers = require("huez.pickers")
    M.n["<leader>sc"] = { pickers.themes, "[S]earch [C]olorschemes" }
  else
    M.n["<leader>sc"] = { builtin.colorscheme, "[S]earch [C]olorschemes" }
  end

  -- INFO: Explorer
  if is_available("telescope-file-browser.nvim") then
    M.n["<leader>e"] = {
      function()
        extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
      end,
      { desc = "Toggle [E]xplorer", noremap = true },
    }
  end

  -- INFO: Project & session management
  if is_available("neovim-project") then
    -- local neovimProject = require('neovim-project');
    M.n["<leader>Wl"] = {
      function()
        extensions["neovim-project"].discover()
      end,
      "[W]orkspace [L]ist",
    }
    M.n["<leader>Wr"] = {
      function()
        extensions["neovim-project"].history()
      end,
      "[W]orkspace [R]ecent",
    }
    M.n["<leader>Ws"] = { "<cmd>NeovimProjectLoadRecent<cr>", "[W]orkspace [S]tart" }
  end

  if is_available("neovim-session-manager") then
    local session = require("session_manager")
    M.n["<leader>Sl"] = { session.load_session, "[S]ession [L]ist" }
    M.n["<leader>Sr"] = { session.load_last_session, "[S]ession [R]ecent" }
    M.n["<leader>Ss"] = { session.save_current_session, "[S]ession [S]ave" }
    M.n["<leader>Sd"] = { session.delete_session, "[S]ession [D]elete" }
  end

  -- INFO: Notifications
  if is_available("nvim-notify") then
    local notify = require("notify")
    M.n["<leader>sn"] = {
      function()
        require("telescope").extensions.notify.notify()
      end,
      "[S]earch [N]otifications",
    }
    M.n["<leader>unc"] = { notify.dismiss, "[U]I [N]otifications [C]lear" }
  end

  -- INFO: Todo comments
  if is_available("todo-comments.nvim") then
    M.n["<leader>st"] = { "<cmd>TodoTelescope<cr>", "[S]earch [T]odoComments" }
  end

  --INFO: undo tree
  if is_available("telescope-undo.nvim") then
    M.n["<leader>su"] = { "<cmd>Telescope undo<cr>", "[S]earch [U]ndo" }
  end
end
--
-- INFO: diagnostics
M.n["[d"] = { vim.diagnostic.get_prev, "Go to previous diagnostic message" }
M.n["]d"] = { vim.diagnostic.get_next, "Go to next diagnostic message" }
M.n["<leader>dm"] = {
  vim.diagnostic.open_float,
  "[D]iagnostics [M]essage",
}

-- INFO: Explorer
if is_available("mini.files") then
  local mini_files = require("mini.files")
  M.n["<leader>e"] = {
    function()
      mini_files.open()
    end,
    { desc = "Toggle [E]xplorer", noremap = true },
  }
  M.n["<leader>E"] = {
    function()
      mini_files.open(vim.api.nvim_buf_get_name(0))
      -- mini_files.reveal_cwd()
    end,
    { desc = "Toggle [E]xplorer at file path", noremap = true },
  }
end

-- INFO: Buffers
if is_available("mini.bufremove") then
  M.n["<leader>bd"] = {
    function()
      require("mini.bufremove").delete(0, false)
    end,
    "[B]uffer [D]elete",
  }
  M.n["<leader>bD"] = {
    function()
      require("mini.bufremove").delete(0, true)
    end,
    "[B]uffer [D]elete (force)",
  }
else
  -- INFO: {bp} move to previous buffer | {bd  #} delete buffer we just left
  M.n["<leader>bd"] = { ":bp|bd #<cr>", "[B]uffer [D]elete" }
end
M.n["<leader>bn"] = { "<cmd>enew<cr>", "[B]uffer [N]ew" }
M.n["<leader>bs"] = { "<cmd>w<cr>", "[B]uffer [S]ave" }

if is_available("conform.nvim") then
  M.n["<leader>bf"] = {
    function()
      require("conform").format({ async = true, lsp_fallback = true })
    end,
    "[B]uffer [F]ormat",
  }
else
  M.n["<leader>bf"] = {
    function()
      vim.lsp.buf.format({ async = true })
    end,
    "[B]uffer [F]ormat",
  }
end

-- INFO: Windows
M.n["<leader>wd"] = { "<C-w>c", "[W]indow [D]elete" }

-- INFO: Terminals
if is_available("toggleterm.nvim") then
  vim.keymap.set(
    { "n", "t" },
    "<C-/>",
    "<cmd>ToggleTerm direction=float<cr>",
    { noremap = true, silent = true, desc = "Toggle floating Term" }
  )
  vim.keymap.set(
    { "n", "t" },
    "<leader>th",
    "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
    { desc = "[T]oggleTerm [H]orizontal split" }
  )
  vim.keymap.set(
    { "n", "t" },
    "<leader>tv",
    "<cmd>ToggleTerm size=80 direction=vertical<cr>",
    { desc = "[T]oggleTerm [V]ertical split" }
  )
  local opts = { noremap = true, silent = true }
  vim.keymap.set({ "t", "n" }, "<esc>", [[<C-\><C-n>]], opts)
end
M.n["<leader>td"] = { "<C-w>c", "[T]erminal [D]elete" }

-- INFO: highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  M.n["<leader>uc"] = { vim.show_pos, "UI show cursor position" }
end

-- INFO: Move Lines
if not is_available("mini.move") then
  M.n["<S-j>"] = { "<cmd>m .+1<cr>==", { desc = "Move line down", noremap = true } }
  M.n["<S-k>"] = { "<cmd>m .-2<cr>==", { desc = "Move line up", noremap = true } }
  M.i["<S-j>"] = { "<esc><cmd>m .+1<cr>==gi", "Move line down" }
  M.i["<S-k>"] = { "<esc><cmd>m .-2<cr>==gi", "Move line up" }
  M.v["<S-j>"] = { ":m '>+1<cr>gv=gv", "Move line down" }
  M.v["<S-k>"] = { ":m '<-2<cr>gv=gv", "Move line up" }
end

if not is_available("grug-far") then
  M.n["<leader>cs"] = { "<cmd>GrugFar<cr>", "[C]ode [S]earch and replace" }
end

--INFO: Neovide
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0

  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  M.n["<S-UP>"] = {
    function()
      change_scale_factor(1.05)
    end,
    "Scale UP",
  }
  M.n["<S-DOWN>"] = {
    function()
      change_scale_factor(1 / 1.05)
    end,
    "Scale DOWN",
  }
end

-- INFO: Remap for dealing with word wrap
-- M.n["k"] = { "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } }
-- M.n["j"] = { "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } }
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- M.v["k"] = { "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } }
-- M.v["j"] = { "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } }

-- INFO: Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- INFO: remove char without yanking into register
vim.keymap.set("n", "x", '"_x')

-- INFO: Plugin manager (Lazy.nvim)
M.n["<leader>ph"] = { lazy.home, "[P]lugins [H]ome" }
M.n["<leader>pi"] = { lazy.install, "[P]lugins [I]nstall" }
M.n["<leader>ps"] = { lazy.sync, "[P]lugins [S]ync" }
M.n["<leader>pc"] = { lazy.check, "[P]lugins [C]heck Updates" }
M.n["<leader>pu"] = { lazy.update, "[P]lugins [U]pdate" }

--[INFO:] DAP

if is_available("nvim-dap") then
  local dap = require("dap")
  -- Navigation debug
  M.n["<leader>dc"] = { dap.continue, "DAP: Continue / Start" }
  M.n["<leader>dn"] = { dap.step_over, "DAP: Next (step over)" }
  M.n["<leader>di"] = { dap.step_into, "DAP: Into (step into)" }
  M.n["<leader>do"] = { dap.step_out, "DAP: Out (step out)" }
  M.n["<leader>dx"] = { dap.terminate, "DAP: Terminate" }

  -- Breakpoints
  M.n["<leader>db"] = { dap.toggle_breakpoint, "DAP: Toggle Breakpoint" }
  M.n["<leader>dB"] = {
    function()
      dap.set_breakpoint(vim.fn.input("Condition: "))
    end,
    "DAP: Breakpoint conditionnel",
  }
  M.n["<leader>dl"] = { dap.clear_breakpoints, "DAP: Clear all breakpoints" }
end
-- UI
if is_available("nvim-dap-ui") then
  local dapui = require("dapui")
  M.n["<leader>du"] = { dapui.toggle, "DAP: Toggle UI" }
  M.n["<leader>de"] = { dapui.eval, "DAP: Eval expression" }
  M.v["<leader>de"] = { dapui.eval, "DAP: Eval selection" }
end

-- INFO: LSP
-- M.n["gd"] = { vim.lsp.buf.definition, "[G]o to [D]efinition" }
-- M.n["gD"] = { vim.lsp.buf.declaration, "[G]o to [D]eclaration" }
-- M.n["gI"] = { vim.lsp.buf.implementation, "[G]o to [I]mplementation" }
-- M.n["<leader>lh"] = { vim.lsp.buf.hover, "[L]SP [H]over Documentation" }
-- M.n["<leader>lD"] = { vim.lsp.buf.type_definition, "[L]SP Type [D]efinition" }
-- M.n["<leader>cr"] = { vim.lsp.buf.rename, "[C]ode [R]ename" }
-- M.n["<leader>ca"] = { vim.lsp.codelens.run, "[C]odelens [A]ction" }

-- NOTE: Hop
if is_available("hop.nvim") then
  local hop = require("hop")
  local directions = require("hop.hint").HintDirection
  vim.keymap.set("", "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
  end, { remap = true })
  vim.keymap.set("", "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
  end, { remap = true })
end

if is_available("persistence.nvim") then
  local persistence = require("persistence")
  M.n["<leader>Sr"] = { persistence.load, "[S]ession [R]estore" }
  -- M.n['<leader>Sr'] = {persistence.load, "[S]ession [R]estore"}
end

if is_available("nvim-ufo") then
  local ufo = require("ufo")
  M.n["zR"] = { ufo.openAllFolds, "Open all folds" }
  M.n["zM"] = { ufo.closeAllFolds, "Close all folds" }
end

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", noremap = true })

applyMapping(M)
