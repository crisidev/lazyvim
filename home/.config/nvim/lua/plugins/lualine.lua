return {
    "nvim-lualine/lualine.nvim",
    opts = function()
        -- PERF: we don't need this lualine require madness 🤷
        local lualine_require = require("lualine_require")
        lualine_require.require = require
        local colors = require("config.theme").colors
        local icons = require("config.theme").icons
        local lualine = require("utils.lualine")

        vim.o.laststatus = vim.g.lualine_laststatus

        return {
            options = {
                theme = require("config.theme").lualine(),
                globalstatus = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                always_divide_middle = true,
                disabled_filetypes = {
                    "dashboard",
                    "NvimTree",
                    "neo-tree",
                    "Outline",
                    "alpha",
                    "vista",
                    "vista_kind",
                    "TelescopePrompt",
                },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        lualine.vim_mode,
                        color = function()
                            return { fg = lualine.mode_color[vim.fn.mode()], bg = colors.bg }
                        end,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "b:gitsigns_head",
                        icon = " " .. icons.git,
                        cond = lualine.conditions.check_git_workspace,
                        color = { fg = colors.blue, bg = colors.bg },
                        padding = 0,
                    },
                    {
                        lualine.file_icon,
                        padding = { left = 2, right = 0 },
                        cond = lualine.conditions.buffer_not_empty,
                        color = "LualineFileIconColor",
                        gui = "bold",
                    },
                    {
                        lualine.file_name,
                        padding = { left = 1, right = 1 },
                        color = { fg = colors.fg, gui = "bold", bg = colors.bg },
                        cond = lualine.conditions.buffer_not_empty,
                    },
                    {
                        "diff",
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                        symbols = {
                            added = icons.added,
                            modified = icons.modified,
                            removed = icons.removed,
                        },
                        diff_color = {
                            added = { fg = colors.git.add, bg = colors.bg },
                            modified = { fg = colors.git.change, bg = colors.bg },
                            removed = { fg = colors.git.delete, bg = colors.bg },
                        },
                        color = {},
                    },
                    {
                        function()
                            return icons.circle_right
                        end,
                        padding = { left = 0, right = 0 },
                        color = { fg = colors.bg },
                    },
                },

                lualine_x = {
                    {
                        function()
                            return icons.circle_left
                        end,
                        padding = { left = 0, right = 0 },
                        color = { fg = colors.bg },
                    },
                    {
                        lualine.file_read_only,
                        color = { fg = colors.red },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = icons.error, warn = icons.warn, info = icons.info, hint = icons.hint },
                        cond = lualine.conditions.hide_in_width,
                        color = { fg = colors.fg, bg = colors.bg },
                    },
                    {
                        function()
                            return " " .. lualine.lsp_server_icon("null-ls", icons.code_lens_action)
                        end,
                        padding = 0,
                        color = { fg = colors.blue, bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {
                        lualine.codeium,
                        padding = 0,
                        color = { fg = colors.purple, bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {

                        function()
                            return lualine.lsp_server_icon("typos_lsp", icons.typos)
                        end,
                        padding = 0,
                        color = { fg = colors.yellow, bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {
                        lualine.treesitter,
                        padding = 0,
                        color = { fg = colors.green, bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {
                        lualine.lsp_servers,
                        color = { fg = colors.fg, bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {
                        "location",
                        padding = 0,
                        color = { fg = colors.orange, bg = colors.bg },
                    },
                    {
                        lualine.file_size,
                        cond = lualine.conditions.buffer_not_empty,
                        color = { fg = colors.fg, bg = colors.bg },
                    },
                    {
                        "fileformat",
                        fmt = string.upper,
                        icons_enabled = true,
                        color = { fg = colors.green, gui = "bold", bg = colors.bg },
                        cond = lualine.conditions.hide_in_width,
                    },
                    {
                        lualine.file_position,
                        padding = 0,
                        color = { fg = colors.yellow, bg = colors.bg },
                    },
                },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = { "neo-tree", "lazy" },
        }
    end,
}
