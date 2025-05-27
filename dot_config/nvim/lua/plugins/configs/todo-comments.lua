--  FIX(@author): this
-- [BUG](@author): this
-- [ERR](@author): this
-- [ERROR](@author): this
-- [FAIL](@author): this
-- [FATAL](@author): this
-- [FIXME](@author): this
-- [KO](@author): this
--  TODO(@author): that
-- [TODO]: that
--  HACK: plus
-- [HACK]: plus
-- [TRACE]: plus
--[WARN]: plus
--[WARNING]: plus
-- OPTIM(@toto): optimus
-- INFO: big brain
-- [INFO]: big brain
-- [NOTE]: big brain
-- [MARK]: big brain
-- [OK]: big brain
-- [VERBOSE]: big brain
--  TEST: test
-- [DEBUG](@author): this
-- #ff007c

return {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = {
        "FIXME",
        "BUG",
        "KO",
        "ERROR",
        "ERR",
        "FIXIT",
        "ISSUE",
        "FAIL",
        "FATAL",
        "FIXME",
      }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "hack", alt = { "TRACE" } },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = {
      icon = " ",
      color = "perf",
      alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
    },
    NOTE = {
      icon = " ",
      color = "hint",
      alt = { "INFO", "MARK", "OK", "PASS", "VERBOSE" },
    },
    TEST = {
      icon = "⏲ ",
      color = "test",
      alt = { "TESTING", "PASSED", "FAILED", "DEBUG" },
    },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  colors = {
    -- hint = { "#10B981" },
    perf = { "#89ddff", "#1E81B0" },
    hack = { "#ffe082", "#FBBF24" },
  },
  highlight = {
    pattern = [[.*<(\[?(KEYWORDS)\]?%(\(.{-1,}\))?):]],
  },
  search = {
    pattern = [[\b(\[?KEYWORDS\]?)(\([^\)]*\))?:]],
  },
}
