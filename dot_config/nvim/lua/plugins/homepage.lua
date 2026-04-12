return {
  "echasnovski/mini.starter",
  version = false,
  config = function()
    local starter = require("mini.starter")

    starter.setup({
      header = table.concat({
        "            ██████            ",
        "        ████▒▒▒▒▒▒████        ",
        "      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      ",
        "    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ",
        "  ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒      ",
        "  ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓  ",
        "  ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓  ",
        "██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██",
        "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
        "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
        "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
        "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
        "██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██",
        "████  ██▒▒██  ██▒▒▒▒██  ██▒▒██",
        "██      ██      ████      ████",
      }, "\n"),
      items = {
        starter.sections.recent_files(5, true), -- 5 fichiers récents (cwd)
        starter.sections.recent_files(5, false), -- 5 fichiers récents (global)
        {
          { name = "Find File", action = "Telescope find_files", section = "Telescope" },
          { name = "Find Word", action = "Telescope live_grep", section = "Telescope" },
          { name = "Projects", action = "NeovimProjectDiscover", section = "Projects" },
        },
        {
          { name = "New File", action = "enew", section = "Actions" },
          { name = "Lazy", action = "Lazy", section = "Actions" },
          { name = "Quit", action = "qa", section = "Actions" },
        },
      },
      content_hooks = {
        starter.gen_hook.adding_bullet("  "),
        starter.gen_hook.aligning("center", "center"),
      },

      footer = function()
        local stats = require("lazy").stats()

        return string.format("⚡ %d plugins en %.0fms", stats.loaded, stats.startuptime)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        if vim.bo.filetype == "ministarter" then
          pcall(require("mini.starter").refresh)
        end
      end,
    })
  end,
}
