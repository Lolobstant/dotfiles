return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    -- "JoosepAlviste/nvim-ts-context-commentstring",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "lua",
      "tsx",
      "typescript",
      "graphql",
      "json",
      "scss",
      "vimdoc",
      "vim",
      "comment",
      "css",
      "diff",
      "dockerfile",
      "gitcommit",
      "gitignore",
      "html",
      "c",
      "lua",
      "luadoc",
      "jsdoc",
      "markdown",
      "nix",
      "python",
      "regex",
      "toml",
      "yaml",
      "xml",
    },
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = true, use_languagetree = true },
    indent = { enable = true },
    incremental_selection = { enable = true, keymaps = { node_incremental = "v", node_decremental = "V" } },
    autotag = { enable = true },
    ts_context_commentstring = { enable = true, enable_autocmd = false },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter")

    -- local configs = require("nvim-treesitter.configs")
    ts.setup({})

    local alreadyInstalled = ts.get_installed()
    local parsersToInstall = vim
      .iter(opts.ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    if #parsersToInstall > 0 then
      ts.install(parsersToInstall)
    end
  end,
}
