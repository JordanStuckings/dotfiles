return {
  {
    "folke/tokyonight.nvim",
    enabled = false, -- Disable default LazyVim theme
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- Define colors
        local colors = {
          bg = "#111c18",
          fg = "#C1C497",
          cursor = "#D7C995",
          -- Normal colors
          black = "#23372B",
          red = "#FF5345",
          green = "#549e6a",
          yellow = "#459451",
          blue = "#509475",
          magenta = "#D2689C",
          cyan = "#2DD5B7",
          white = "#F6F5DD",

          -- Bright colors
          bright_black = "#53685B",
          bright_red = "#db9f9c",
          bright_green = "#63b07a",
          bright_yellow = "#E5C736",
          bright_blue = "#ACD4CF",
          bright_magenta = "#75bbb3",
          bright_cyan = "#8CD3CB",
          bright_white = "#9eebb3",
        }

        local function hi(group, opts)
          local cmd = "hi " .. group
          if opts.fg then
            cmd = cmd .. " guifg=" .. opts.fg
          end
          if opts.bg then
            cmd = cmd .. " guibg=" .. opts.bg
          end
          if opts.style then
            cmd = cmd .. " gui=" .. opts.style
          end
          if opts.sp then
            cmd = cmd .. " guisp=" .. opts.sp
          end
          vim.cmd(cmd)
        end

        vim.cmd("hi clear")
        if vim.fn.exists("syntax_on") then
          vim.cmd("syntax reset")
        end
        vim.o.background = "dark"
        vim.g.colors_name = "osaka-jade"

        -- Editor (with transparency)
        hi("Normal", { fg = colors.fg, bg = "NONE" })
        hi("NormalFloat", { fg = colors.fg, bg = "NONE" })
        hi("FloatBorder", { fg = colors.cyan, bg = "NONE" })
        hi("Cursor", { fg = colors.bg, bg = colors.cursor })
        hi("CursorLine", { bg = colors.black })
        hi("CursorLineNr", { fg = colors.cyan, style = "bold" })
        hi("LineNr", { fg = colors.bright_black })
        hi("SignColumn", { bg = "NONE" })
        hi("Visual", { bg = colors.blue })
        hi("VisualNOS", { bg = colors.blue })
        hi("Search", { fg = colors.bg, bg = colors.bright_yellow })
        hi("IncSearch", { fg = colors.bg, bg = colors.cyan })

        -- Syntax
        hi("Comment", { fg = colors.bright_black, style = "italic" })
        hi("Constant", { fg = colors.magenta })
        hi("String", { fg = colors.green })
        hi("Character", { fg = colors.green })
        hi("Number", { fg = colors.magenta })
        hi("Boolean", { fg = colors.magenta })
        hi("Float", { fg = colors.magenta })
        hi("Identifier", { fg = colors.cyan })
        hi("Function", { fg = colors.blue })
        hi("Statement", { fg = colors.bright_magenta })
        hi("Conditional", { fg = colors.bright_magenta })
        hi("Repeat", { fg = colors.bright_magenta })
        hi("Label", { fg = colors.bright_magenta })
        hi("Operator", { fg = colors.cyan })
        hi("Keyword", { fg = colors.bright_magenta })
        hi("Exception", { fg = colors.red })
        hi("PreProc", { fg = colors.cyan })
        hi("Include", { fg = colors.bright_magenta })
        hi("Define", { fg = colors.bright_magenta })
        hi("Macro", { fg = colors.cyan })
        hi("Type", { fg = colors.bright_yellow })
        hi("StorageClass", { fg = colors.bright_yellow })
        hi("Structure", { fg = colors.bright_yellow })
        hi("Special", { fg = colors.cyan })
        hi("SpecialChar", { fg = colors.bright_green })
        hi("Tag", { fg = colors.cyan })
        hi("Delimiter", { fg = colors.fg })
        hi("SpecialComment", { fg = colors.bright_black, style = "italic" })
        hi("Debug", { fg = colors.red })
        hi("Underlined", { style = "underline" })
        hi("Error", { fg = colors.red })
        hi("Todo", { fg = colors.bright_yellow, style = "bold" })

        -- Treesitter
        hi("@variable", { fg = colors.fg })
        hi("@variable.builtin", { fg = colors.magenta })
        hi("@function", { fg = colors.blue })
        hi("@function.builtin", { fg = colors.cyan })
        hi("@function.macro", { fg = colors.cyan })
        hi("@keyword", { fg = colors.bright_magenta })
        hi("@keyword.function", { fg = colors.bright_magenta })
        hi("@keyword.operator", { fg = colors.bright_magenta })
        hi("@operator", { fg = colors.cyan })
        hi("@string", { fg = colors.green })
        hi("@string.escape", { fg = colors.bright_green })
        hi("@type", { fg = colors.bright_yellow })
        hi("@type.builtin", { fg = colors.bright_yellow })
        hi("@parameter", { fg = colors.fg })
        hi("@property", { fg = colors.cyan })
        hi("@constructor", { fg = colors.bright_yellow })
        hi("@constant", { fg = colors.magenta })
        hi("@constant.builtin", { fg = colors.magenta })

        -- LSP
        hi("DiagnosticError", { fg = colors.red })
        hi("DiagnosticWarn", { fg = colors.bright_yellow })
        hi("DiagnosticInfo", { fg = colors.cyan })
        hi("DiagnosticHint", { fg = colors.bright_green })
        hi("DiagnosticUnderlineError", { sp = colors.red, style = "undercurl" })
        hi("DiagnosticUnderlineWarn", { sp = colors.bright_yellow, style = "undercurl" })
        hi("DiagnosticUnderlineInfo", { sp = colors.cyan, style = "undercurl" })
        hi("DiagnosticUnderlineHint", { sp = colors.bright_green, style = "undercurl" })

        -- Git
        hi("GitSignsAdd", { fg = colors.green })
        hi("GitSignsChange", { fg = colors.bright_yellow })
        hi("GitSignsDelete", { fg = colors.red })
        hi("DiffAdd", { fg = colors.green, bg = colors.black })
        hi("DiffChange", { fg = colors.bright_yellow, bg = colors.black })
        hi("DiffDelete", { fg = colors.red, bg = colors.black })
        hi("DiffText", { fg = colors.bright_blue, bg = colors.black })

        -- Telescope
        hi("TelescopeBorder", { fg = colors.cyan })
        hi("TelescopePromptBorder", { fg = colors.cyan })
        hi("TelescopeResultsBorder", { fg = colors.cyan })
        hi("TelescopePreviewBorder", { fg = colors.cyan })
        hi("TelescopeSelection", { fg = colors.cyan, bg = colors.black, style = "bold" })
        hi("TelescopeSelectionCaret", { fg = colors.cyan })
        hi("TelescopeMatching", { fg = colors.bright_yellow, style = "bold" })

        -- Neo-tree (with transparency)
        hi("NeoTreeNormal", { fg = colors.fg, bg = "NONE" })
        hi("NeoTreeNormalNC", { fg = colors.fg, bg = "NONE" })
        hi("NeoTreeDirectoryIcon", { fg = colors.blue })
        hi("NeoTreeDirectoryName", { fg = colors.blue })
        hi("NeoTreeFileName", { fg = colors.fg })
        hi("NeoTreeFileNameOpened", { fg = colors.cyan, style = "bold" })
        hi("NeoTreeGitAdded", { fg = colors.green })
        hi("NeoTreeGitModified", { fg = colors.bright_yellow })
        hi("NeoTreeGitDeleted", { fg = colors.red })
        hi("NeoTreeRootName", { fg = colors.cyan, style = "bold" })

        -- Statusline
        hi("StatusLine", { fg = colors.fg, bg = colors.black })
        hi("StatusLineNC", { fg = colors.bright_black, bg = colors.black })

        -- Tabs
        hi("TabLine", { fg = colors.bright_black, bg = colors.black })
        hi("TabLineFill", { bg = "NONE" })
        hi("TabLineSel", { fg = colors.bg, bg = colors.green, style = "bold" })

        -- Popup menu
        hi("Pmenu", { fg = colors.fg, bg = colors.black })
        hi("PmenuSel", { fg = colors.bg, bg = colors.cyan, style = "bold" })
        hi("PmenuSbar", { bg = colors.black })
        hi("PmenuThumb", { bg = colors.bright_black })

        -- Which-key
        hi("WhichKey", { fg = colors.cyan })
        hi("WhichKeyGroup", { fg = colors.blue })
        hi("WhichKeyDesc", { fg = colors.fg })
        hi("WhichKeySeparator", { fg = colors.bright_black })
        hi("WhichKeyFloat", { bg = colors.black })

        -- Notify
        hi("NotifyERRORBorder", { fg = colors.red })
        hi("NotifyWARNBorder", { fg = colors.bright_yellow })
        hi("NotifyINFOBorder", { fg = colors.cyan })
        hi("NotifyDEBUGBorder", { fg = colors.bright_black })
        hi("NotifyTRACEBorder", { fg = colors.bright_magenta })

        -- Dashboard
        hi("DashboardHeader", { fg = colors.cyan })
        hi("DashboardCenter", { fg = colors.blue })
        hi("DashboardShortCut", { fg = colors.magenta })
        hi("DashboardFooter", { fg = colors.bright_black, style = "italic" })
      end,
    },
  },
}
