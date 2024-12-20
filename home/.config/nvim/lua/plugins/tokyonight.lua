local theme = require("config.theme")

local function styles()
    if vim.g.transparent then
        return {
            comments = { italic = true },
            keywords = { italic = true },
            sidebars = "transparent",
            floats = "transparent",
        }
    else
        return {
            comments = { italic = true },
            keywords = { italic = true },
        }
    end
end

local function link(group, other)
    vim.cmd("highlight! link " .. group .. " " .. other)
end

local function set_fg_bg(group, fg, bg)
    vim.cmd("hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

return {
    "folke/tokyonight.nvim",
    opts = {
        style = "storm",
        transparent = vim.g.transparent,
        terminal_colors = true,
        styles = styles(),
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
            col.git = {
                change = theme.colors.git.change,
                add = theme.colors.git.add,
                delete = theme.colors.git.delete,
                conflict = theme.colors.git.conflict,
            }
            if vim.g.transparent then
                vim.cmd([[
                    highlight Normal guibg=none
                    highlight NormalFloat guibg=none
                    highlight NormalNC guibg=none
                    highlight NonText guibg=none
                    highlight Normal ctermbg=none
                    highlight NonText ctermbg=none
                ]])
            end
            vim.cmd("hi DiagnosticUnnecessary guibg=NONE guifg=" .. theme.colors.special_comment)
        end,
        on_highlights = function(hl, c)
            set_fg_bg("SpecialComment", theme.colors.special_comment, "bold")
            link("LspCodeLens", "SpecialComment")
            set_fg_bg("Hlargs", theme.colors.hlargs, "none")
            set_fg_bg("diffAdded", theme.colors.git.add, "NONE")
            set_fg_bg("diffRemoved", theme.colors.git.delete, "NONE")
            set_fg_bg("diffChanged", theme.colors.git.change, "NONE")
            set_fg_bg("SignColumn", theme.colors.bg, "NONE")
            set_fg_bg("SignColumnSB", theme.colors.bg, "NONE")
        end,
        cache = true,
    },
}
