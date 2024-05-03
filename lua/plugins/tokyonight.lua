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
            "vista_kind",
            "terminal",
            "lazy",
            "spectre_panel",
            "NeogitStatus",
            "neo-tree",
            "help",
        },
        day_brightness = 0.3,
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
            hl.CursorLineNr = { fg = theme.colors.orange, style = "bold" }
        end,
    },
}
