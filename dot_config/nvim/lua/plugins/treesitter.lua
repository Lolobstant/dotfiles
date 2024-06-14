return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "tsx", "typescript", "graphql", "json", "scss", "vimdoc", "vim" },
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = true, use_languagetree = true },
    indent = { enable = true },
    incremental_selection = { enable = true, keymaps = { node_incremental = "v", node_decremental = "V" } },
    autotag = { enable = true },
    ts_context_commentstring = { enable = true, enable_autocmd = false },
  },
  config = function(_, opts)
    local configs = require("nvim-treesitter.configs")
    configs.setup(opts)
  end,
}
