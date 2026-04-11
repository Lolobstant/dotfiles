-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        -- Parsers toujours installés
        ensure_installed = {
          "lua",
          "luadoc",
          "tsx",
          "typescript",
          "javascript",
          "jsdoc",
          "json",
          "css",
          "scss",
          "html",
          "graphql",
          "markdown",
          "markdown_inline",
          "yaml",
          "toml",
          "dockerfile",
          "gitcommit",
          "gitignore",
          "python",
          "bash",
          "regex",
          "comment",
          "vim",
          "vimdoc",
          "diff",
          "c",
        },
        -- Auto-install le parser quand tu ouvres un fichier sans parser dispo
        auto_install = true,
      })

      -- Active la coloration tree-sitter native nvim (builtin, pas besoin de plugin)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_highlight", { clear = true }),
        callback = function()
          local ft = vim.bo.filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- Parser dispo → on start direct
          local ok = pcall(vim.treesitter.start)
          if not ok then
            -- Pas dispo → on installe, puis on re-essaie après install
            require("nvim-treesitter").install({ lang }, function()
              pcall(vim.treesitter.start)
            end)
          end
        end,
      })
    end,
  },

  -- Autotag : gère son propre setup, pas besoin de le configurer via treesitter
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    enabled = false, -- en attendant le fix upstream
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },

  -- Textobjects : branche main aussi pour compatibilité 0.12
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- config ici si tu veux des keymaps textobjects,
    -- sinon lazy = true et pas de config = ça charge juste les modules
  },
}
