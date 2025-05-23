return {
    {
        "folke/tokyonight.nvim",
        enabled = vim.g.theme == "tokyonight",
        opts = {
            style = "storm",
            on_highlights = function(hl, c)
                local theme = require("config.theme")
                hl.NormalNC = { fg = theme.colors.fg_dark, bg = "#1c1d28" }
                hl.Normal = { fg = theme.colors.fg, bg = "#1f2335" }
                vim.cmd("hi SpecialComment guifg=" .. theme.colors.special_comment .. " guibg=bold")
                vim.cmd("highlight! link LspCodeLens SpecialComment")
                vim.cmd("hi Hlargs guifg=" .. theme.colors.hlargs .. " guibg=NONE")
                vim.cmd("hi DiagnosticUnnecessary guifg=" .. theme.colors.special_comment .. " guibg=NONE")
            end,
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = vim.g.theme,
        },
    },
}
