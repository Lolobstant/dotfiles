---@module 'simplered'
---@author
---@license MIT

vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") then
  vim.cmd.syntax("reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "simplered"

local function hexToRGB(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255
  return r, g, b
end

local function rgbToHSL(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2
  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, l
end

function HSL(h, s, l)
  -- Helper function to convert hue to RGB
  local function hue_to_rgb(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end
  -- Normalize the input values
  h = (h % 360) / 360
  s = s / 100
  l = l / 100
  local r, g, b
  if s == 0 then
    -- Achromatic color (gray)
    r = l
    g = l
    b = l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue_to_rgb(p, q, h + 1 / 3)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1 / 3)
  end
  -- Convert the RGB values to hexadecimal format
  r = math.floor(r * 255)
  g = math.floor(g * 255)
  b = math.floor(b * 255)
  return string.format("#%02x%02x%02x", r, g, b)
end

function HSL_H(hex)
  local r, g, b = hexToRGB(hex)
  local h, _, _ = rgbToHSL(r, g, b)
  return string.format("%.0f", h * 360)
end

function HSL_S(hex)
  local r, g, b = hexToRGB(hex)
  local _, s, _ = rgbToHSL(r, g, b)
  return string.format("%.0f", s * 100)
end

function HSL_L(hex)
  local r, g, b = hexToRGB(hex)
  local _, _, l = rgbToHSL(r, g, b)
  return string.format("%.0f", l * 100)
end

-- local BaseColor = HSL(235, 19, 13) -- Blue
-- local BaseColor = HSL(20, 15, 12) -- Brown
-- local BaseColor = HSL(20, 10, 12) -- Brown Desaturated
-- local BaseColor = HSL(100, 15, 12) -- Green
-- local BaseColor = HSL(0, 0, 12) -- Grey
-- local BaseColor = HSL(0, 0, 0) -- Black
local BaseColor = HSL(249, 22, 12) -- Rose-Pine Default
-- local BaseColor = HSL(0, 0, 6) -- Custom
local BoldOption = true
local ItalicOption = true
local UnderlineOption = true

local c = {}
c.bg = BaseColor
c.bgH = HSL_H(c.bg)
c.bgS = HSL_S(c.bg)
c.bgL = HSL_L(c.bg)
c.white = HSL(0, 100, 100)
c.black = HSL(0, 0, 0)
c.grey1 = HSL(c.bgH, c.bgS / 1.5, 3)
c.grey2 = HSL(HSL_H(c.bg), c.bgS / 1.5, 7)
c.grey3 = HSL(HSL_H(c.bg), c.bgS / 1.5, 19)
c.grey4 = HSL(HSL_H(c.bg), c.bgS / 1.5, 35)
c.grey5 = HSL(HSL_H(c.bg), c.bgS / 1.5, 54)
c.grey6 = HSL(HSL_H(c.bg), c.bgS / 1.5, 74)
c.grey7 = HSL(HSL_H(c.bg), c.bgS / 1.5, 82)
c.grey8 = HSL(HSL_H(c.bg), c.bgS / 1.5, 93)
c.green = HSL(130, 30, 52)
c.magenta = HSL(280, 50, 70)
c.red1 = HSL(0, 58, 52)
c.red2 = HSL(0, 100, 42)
c.red3 = HSL(0, 100, 34)
c.red4 = HSL(0, 100, 26)
c.ui1 = HSL(c.bgH, c.bgS, c.bgL + 2)
c.ui2 = HSL(c.bgH, c.bgS, c.bgL + 4)
c.ui3 = HSL(c.bgH, c.bgS, c.bgL + 10)
c.ui4 = HSL(c.bgH, c.bgS, c.bgL + 15)

-- NOTE: The aim is the following:
--       - Mainly monochrome, with color for literals (`literal`) and errors (`error`)
--       - Things that require my attention should be in *bold* typeface
--       - Things that don't require my attention should be in *italic* typeface
--       - UI stuff that require attention should be highlighted with accent color
--       - Visual and search will have a "highlighter" style background (`visual`)
--       - Diff status also colored, but it should be subtle

local hlgroups = {
  Normal = { fg = c.grey6 },
  NormalNC = { link = "Normal" },
  MsgArea = { link = "Normal" },
  EndOfBuffer = { link = "Normal" },
  Delimiter = { link = "Normal" },
  Identifier = { link = "Normal" },
  Title = { link = "Normal" },
  Debug = { link = "Normal" },
  Boolean = { link = "Normal" },
  Exception = { link = "Normal" },
  FoldColumn = { link = "Normal" },
  Macro = { link = "Normal" },
  ModeMsg = { link = "Normal" },
  MoreMsg = { link = "Normal" },
  Question = { link = "Normal" },
  NormalFloat = { bg = c.ui1 },
  MsgSeparator = { link = "StatuslineTextMain" },
  Keyword = { fg = c.grey8 },
  Conditional = { link = "Keyword" },
  Statement = { link = "Keyword" },
  Operator = { link = "Keyword" },
  Structure = { link = "Keyword" },
  Function = { link = "Keyword" },
  Include = { link = "Keyword" },
  Type = { link = "Keyword" },
  Typedef = { link = "Keyword" },
  Todo = { link = "Keyword" },
  Label = { link = "Keyword" },
  Define = { link = "Keyword" },
  DiffAdd = { link = "Keyword" },
  diffAdded = { fg = c.green },
  diffCommon = { link = "Keyword" },
  Directory = { link = "Keyword" },
  PreCondit = { link = "Keyword" },
  PreProc = { link = "Keyword" },
  Repeat = { link = "Keyword" },
  Special = { link = "Keyword" },
  SpecialChar = { link = "Keyword" },
  StorageClass = { link = "Keyword" },
  Constant = { fg = c.grey5 }, -- grey5 default
  String = { fg = c.grey5 },
  SpecialComment = { link = "String" },
  Whitespace = { fg = c.ui2 },
  Comment = { fg = c.grey4, italic = ItalicOption },
  NonText = { fg = c.grey4 },
  DiffDelete = { fg = c.grey4 },
  diffRemoved = { fg = c.red1 },
  LineNr = { fg = c.grey4 },
  LineNrAbove = { link = "LineNr" },
  LineNrBelow = { link = "LineNr" },
  CursorLineNr = { fg = c.grey6 },
  Number = { fg = c.red1 },
  Character = { link = "Number" },
  Float = { link = "Number" },
  Tag = { link = "Number" },
  Folded = { link = "Number" },
  WarningMsg = { link = "Number" },
  Error = { fg = c.grey8, bg = c.red4 },
  ErrorMsg = { fg = c.grey8, bg = c.red3 },
  Search = { fg = c.grey1, bg = c.grey5 },
  IncSearch = { fg = c.grey1, bg = c.grey8 },
  Substitute = { link = "IncSearch" },
  DiffChange = { fg = c.red2, bg = c.grey8 },
  diffChanged = { link = "DiffChange" },
  DiffText = { bold = BoldOption, fg = c.grey6, bg = c.red1 },
  SignColumn = { fg = c.red3, bg = c.grey4 },
  SpellBad = { underline = UnderlineOption, fg = c.grey8, bg = c.red4 },
  SpellCap = { fg = c.grey8, bg = c.red3 },
  SpellLocal = { link = "SpellCap" },
  SpellRare = { fg = c.red3 },
  Underlined = { link = "SpellRare" },
  WildMenu = { fg = c.grey4, bg = c.grey8 },
  Pmenu = { fg = c.grey8, bg = c.grey4 },
  PmenuThumb = { fg = c.grey1, bg = c.grey4 },
  SpecialKey = { fg = c.red1 },
  MatchParen = { fg = c.black, bg = c.grey4 },
  CursorLine = { bg = c.ui2 },
  StatusLine = { bold = BoldOption, reverse = true, fg = c.grey5, bg = c.black },
  Cursor = { link = "StatusLine" },
  StatusLineNC = { reverse = true, fg = c.grey3, bg = c.black },
  Visual = { bg = c.ui3 },
  PmenuSbar = { link = "Visual" },
  PmenuSel = { link = "Visual" },
  VisualNOS = { link = "Visual" },
  VertSplit = { link = "Visual" },
  TermCursor = { reverse = true },

  --yankhighlight
  YankHighlight = { fg = c.black, bg = c.Grey7 },

  --statusline
  StatuslineTextMain = { fg = c.Grey8, bg = c.ui4 },
  StatuslineTextAccent = { fg = c.Grey5, bg = c.ui4 },
  StatuslineModeNormal = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineModeInsert = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineModeVisual = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineModeReplace = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineModeCommand = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineModeSelect = { fg = c.Grey8, bg = c.ui4, bold = BoldOption },
  StatuslineFiletype = { fg = c.Grey5, bg = c.ui4 },
  StatuslineSaved = { fg = c.Green, bg = c.ui4 },
  StatuslineNotSaved = { fg = c.red1, bg = c.ui4 },
  StatuslineReadOnly = { fg = c.Grey8, bg = c.ui4 },
  StatuslineLspOn = { fg = c.Grey8, bg = c.ui4 },
  StatuslineLspError = { fg = c.Grey8, bg = c.ui4 },
  StatuslineLspWarning = { fg = c.Grey8, bg = c.ui4 },
  StatuslineLspInfo = { fg = c.Grey8, bg = c.ui4 },
  StatuslineLspHint = { fg = c.Grey8, bg = c.ui4 },
  StatuslineHarpoon = { fg = c.magenta, bg = c.ui4 },

  -- Treesitter
  -- IDENTIFIERS
  ["@variable"] = { link = "Identifier" }, -- Default Link: Identifier
  ["@variable.builtin"] = { link = "@variable" },
  ["@variable.parameter"] = { link = "@variable" },
  ["@variable.parameter.builtin"] = { link = "@variable.parameter" },
  ["@variable.member"] = { link = "@variable" },
  ["@constant"] = { link = "Constant" }, -- Default Link: Constant
  ["@constant.builtin"] = { link = "@constant" }, -- Default Link: Special
  ["@constant.macro"] = { link = "@constant" }, -- Default Link: Define
  ["@module"] = { link = "Identifier" },
  ["@module.builtin"] = { link = "@module" },
  ["@label"] = { link = "Label" }, -- Default Link: Label
  -- LITERALS
  ["@string"] = { link = "Constant" }, -- Default Link: Constant
  ["@string.documentation"] = { link = "@string" },
  ["@string.regexp"] = { link = "@string" },
  ["@string.escape"] = { link = "@string" }, -- Default Link: SpecialChar
  ["@string.special"] = { link = "@string" }, -- Default Link: SpecialChar
  ["@string.special.symbol"] = { link = "@string.special" },
  ["@string.special.url"] = { link = "@string.special" },
  ["@string.special.path"] = { link = "@string.special" },
  ["@character"] = { link = "Character" }, -- Default Link: Character
  ["@character.special"] = { link = "@character" }, -- Default Link: SpecialChar
  ["@boolean"] = { link = "Boolean" }, -- Default Link: Boolean
  ["@number"] = { link = "Number" }, -- Default Link: Number
  ["@number.float"] = { link = "@number" },
  -- TYPES
  ["@type"] = { link = "Type" }, -- Default Link: Type
  ["@type.builtin"] = { link = "@type" },
  ["@type.definition"] = { link = "@type" }, -- Default Link: Typedef
  ["@attribute"] = { link = "@type" },
  ["@attribute.builtin"] = { link = "@attribute" },
  ["@property"] = { link = "Identifier" }, -- Default Link: Identifier
  -- FUNCTIONS
  ["@function"] = { link = "Function" }, -- Default Link: Function
  ["@function.builtin"] = { link = "@function" }, -- Default Link: Special
  ["@function.call"] = { link = "@function" },
  ["@function.macro"] = { link = "@function" }, -- Default Link: Macro
  ["@function.method"] = { link = "@function" },
  ["@function.method.call"] = { link = "@function.method" },
  ["@constructor"] = { link = "Special" }, -- Default Link: Special
  ["@operator"] = { link = "Operator" }, -- Default Link: Operator
  -- KEYWORDS
  ["@keyword"] = { link = "Keyword" }, -- Default Link: Keyword
  ["@keyword.coroutine"] = { link = "@keyword" },
  ["@keyword.function"] = { link = "@keyword" },
  ["@keyword.operator"] = { link = "@keyword" },
  ["@keyword.import"] = { link = "@keyword" },
  ["@keyword.type"] = { link = "@keyword" },
  ["@keyword.modifier"] = { link = "@keyword" },
  ["@keyword.repeat"] = { link = "@keyword" },
  ["@keyword.return"] = { link = "@keyword" },
  ["@keyword.debug"] = { link = "@keyword" },
  ["@keyword.exception"] = { link = "@keyword" },
  ["@keyword.conditional"] = { link = "@keyword" },
  ["@keyword.conditional.ternary"] = { link = "@keyword.conditional" },
  ["@keyword.directive"] = { link = "@keyword" },
  ["@keyword.directive.define"] = { link = "@keyword.directive" },
  -- PUNCTUATION
  ["@punctuation"] = { link = "Delimiter" }, -- Default Link: Delimiter
  ["@punctuation.delimiter"] = { link = "@punctuation" },
  ["@punctuation.bracket"] = { link = "@punctuation" },
  ["@punctuation.special"] = { link = "@punctuation" },
  -- COMMENTS
  ["@comment"] = { link = "Comment" }, -- Default Link: Comment
  ["@comment.documentation"] = { link = "@comment" },
  ["@comment.error"] = { link = "@comment" },
  ["@comment.warning"] = { link = "@comment" },
  ["@comment.todo"] = { link = "@comment" },
  ["@comment.note"] = { link = "@comment" },
  -- MARKUP
  ["@markup"] = {},
  ["@markup.strong"] = { bold = BoldOption },
  ["@markup.italic"] = { link = "@markup" },
  ["@markup.strikethrough"] = { strikethrough = true },
  ["@markup.underline"] = { underline = UnderlineOption },
  ["@markup.heading"] = { link = "@markup" },
  ["@markup.heading.1"] = { link = "@markup.heading" },
  ["@markup.heading.2"] = { link = "@markup.heading" },
  ["@markup.heading.3"] = { link = "@markup.heading" },
  ["@markup.heading.4"] = { link = "@markup.heading" },
  ["@markup.heading.5"] = { link = "@markup.heading" },
  ["@markup.heading.6"] = { link = "@markup.heading" },
  ["@markup.quote"] = { link = "@markup" },
  ["@markup.math"] = { link = "@markup" },
  ["@markup.link"] = { link = "@markup" },
  ["@markup.link.label"] = { link = "@markup.link" },
  ["@markup.link.url"] = { link = "@markup.link" },
  ["@markup.raw"] = { link = "@markup" },
  ["@markup.raw.block"] = { link = "@markup.raw" },
  ["@markup.list"] = { link = "@markup" },
  ["@markup.list.checked"] = { link = "@markup.list" },
  ["@markup.list.unchecked"] = { link = "@markup.list" },
  -- DIFF
  ["@diff.plus"] = {},
  ["@diff.minus"] = {},
  ["@diff.delta"] = {},
  -- TAG
  ["@tag"] = { link = "Tag" }, -- Default Link: Tag
  ["@tag.builtin"] = { link = "@tag" },
  ["@tag.attribute"] = { link = "@tag" },
  ["@tag.delimiter"] = { link = "@tag" },
  -- SPELL
  ["@spell"] = {},
  ["@nospell"] = {},
  -- OTHER
  ["@none"] = {},
  ["@conceal"] = {},

  -- Telescope
  TelescopeNormal = { fg = c.Grey6 }, -- Default Link: Normal
  TelescopeBorder = { link = "TelescopeNormal" },
  TelescopePromptBorder = { link = "TelescopeBorder" },
  TelescopeResultsBorder = { link = "TelescopeBorder" },
  TelescopePreviewBorder = { link = "TelescopeBorder" },
  TelescopeTitle = { link = "TelescopeBorder" },
  TelescopePromptTitle = { link = "TelescopeTitle" },
  TelescopeResultsTitle = { link = "TelescopeTitle" },
  TelescopePreviewTitle = { link = "TelescopeTitle" },
  TelescopePromptNormal = { link = "TelescopeNormal" },
  TelescopeResultsNormal = { link = "TelescopeNormal" },
  TelescopePreviewNormal = { link = "TelescopeNormal" },
  TelescopePreviewMessage = { link = "TelescopePreviewNormal" },
  TelescopePreviewMessageFillchar = { link = "TelescopePreviewMessage" },
  TelescopeSelection = { link = "Visual" }, -- Default Link: Visual
  TelescopeSelectionCaret = { link = "TelescopeSelection" },
  TelescopeMultiIcon = {}, -- Default Link: Identifier
  TelescopeMultiSelection = { fg = c.Grey8, bold = BoldOption }, -- Default Link: Type
  TelescopeMatching = { fg = c.Grey5 }, -- Default Link: Special
  TelescopePromptPrefix = {}, -- Default Link: Identifier
  TelescopePromptCounter = { link = "TelescopeResultsComment" }, -- Default Link: NonText
  TelescopeResultsComment = { fg = c.Grey4 }, -- Default Link: Comment
  TelescopeResultsNumber = {}, -- Default Link: Number
  TelescopeResultsIdentifier = {}, -- Default Link: Identifier
  TelescopeResultsLineNr = {}, -- Default Link: LineNr
  TelescopeResultsVariable = {}, -- Default Link: SpecialChar
  TelescopeResultsStruct = {}, -- Default Link: Struct
  TelescopeResultsOperator = {}, -- Default Link: Operator
  TelescopeResultsDiffAdd = {}, -- Default Link: DiffAdd
  TelescopeResultsMethod = {}, -- Default Link: Method
  TelescopeResultsFunction = {}, -- Default Link: Function
  TelescopeResultsField = {}, -- Default Link: Function
  TelescopeResultsConstant = {}, -- Default Link: Constant
  TelescopeResultsClass = {}, -- Default Link: Function
  TelescopeResultsDiffChange = {}, -- Default Link: DiffChange
  TelescopeResultsDiffUntracked = {}, -- Default Link: NonText
  TelescopeResultsDiffDelete = {}, -- Default Link: DiffDelete
  TelescopeResultsSpecialComment = {}, -- Default Link: SpecialComment
  TelescopePreviewSticky = {}, -- Default Link: Keyword
  TelescopePreviewHyphen = {}, -- Default Link: NonText
  TelescopePreviewExecute = {}, -- Default Link: String
  TelescopePreviewWrite = {}, -- Default Link: Statement
  TelescopePreviewRead = {}, -- Default Link: Constant
  TelescopePreviewSocket = {}, -- Default Link: Statement
  TelescopePreviewLink = {}, -- Default Link: Special
  TelescopePreviewBlock = {}, -- Default Link: Constant
  TelescopePreviewDirectory = {}, -- Default Link: Directory
  TelescopePreviewCharDev = {}, -- Default Link: Constant
  TelescopePreviewPipe = {}, -- Default Link: Constant
  TelescopePreviewMatch = {}, -- Default Link: Search
  TelescopePreviewLine = {}, -- Default Link: Visual
  TelescopePreviewSize = {}, -- Default Link: String
  TelescopePreviewDate = {}, -- Default Link: Directory
  TelescopePreviewGroup = {}, -- Default Link: Constant
  TelescopePreviewUser = {}, -- Default Link: Constant
}

-- Autocommands (source: https://github.com/folke/tokyonight.nvim/blob/f9e738e2dc78326166f11c021171b2e66a2ee426/lua/tokyonight/util.lua#L67)
local augroup = vim.api.nvim_create_augroup("simplered", { clear = true })
vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = augroup,
  callback = function()
    vim.api.nvim_del_augroup_by_id(augroup)
  end,
})

local function set_whl()
  local win = vim.api.nvim_get_current_win()
  local whl = vim.split(vim.wo[win].winhighlight, ",")
  vim.list_extend(whl, { "Normal:NormalSB", "SignColumn:SignColumnSB", "WinSeparator:WinSeparatorSB" })
  whl = vim.tbl_filter(function(hl)
    return hl ~= ""
  end, whl)
  vim.opt_local.winhighlight = table.concat(whl, ",")
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "qf", "lazy", "mason", "help", "oil", "undotree", "diff", "gitcommit" },
  callback = set_whl,
})
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = set_whl,
})

for group, highlight in pairs(hlgroups) do
  vim.api.nvim_set_hl(0, group, highlight)
end
