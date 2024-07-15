local theme = require("config.theme")

return {
    "folke/tokyonight.nvim",
    opts = {
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "transparent",
            floats = "transparent",
        },
        sidebars = {
            "qf",
            "lazy",
            "spectre_panel",
            "neo-tree",
            "help",
            "neotest-summary",
        },
        hide_inactive_statusline = true,
        dim_inactive = true,
        lualine_bold = true,
        on_colors = function(col)
            col.git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" }
            col.bg_dark = "#1a1e30"
            col.bg_dim = "#1f2335"
            col.bg_float = "#1a1e30"
        end,
        on_highlights = function(hl, c)
            c.bg_dark = "#1a1e30"
            c.bg_dim = "#1f2335"
            c.bg_float = "#1a1e30"
            hl["@variable"] = { fg = c.fg }
            hl.NormalFloat = { fg = theme.colors.fg, bg = "#181924" }
            hl.Cursor = { fg = theme.colors.bg, bg = theme.colors.fg }
            hl.NormalNC = { fg = theme.colors.fg_dark, bg = "#1c1d28" }
            hl.Normal = { fg = theme.colors.fg, bg = "#1f2335" }
            hl.CursorLineNr = { fg = theme.colors.orange }
            local function link(group, other)
                vim.cmd("highlight! link " .. group .. " " .. other)
            end

            local function set_fg_bg(group, fg, bg)
                vim.cmd("hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
            end

            set_fg_bg("SpecialComment", "#9ca0a4", "bold")
            link("LspCodeLens", "SpecialComment")
            set_fg_bg("Hlargs", theme.colors.hlargs, "none")
            set_fg_bg("diffAdded", theme.colors.git.add, "NONE")
            set_fg_bg("diffRemoved", theme.colors.git.delete, "NONE")
            set_fg_bg("diffChanged", theme.colors.git.change, "NONE")
            set_fg_bg("SignColumn", theme.colors.bg, "NONE")
            set_fg_bg("SignColumnSB", theme.colors.bg, "NONE")

            local bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
            local hl = vim.api.nvim_get_hl(0, { name = "Folded" })
            hl.bg = bg
            vim.api.nvim_set_hl(0, "Folded", { fg = hl.fg, bg = hl.bg })
            -- vim.opt.foldtext = [[luaeval('HighlightedFoldtext')()]]
        end,
    },
}
