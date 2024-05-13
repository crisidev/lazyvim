local colors = require("config.theme").colors
local icons = require("config.theme").icons
local lazy_icons = require("lazyvim.config").icons
local lualine = require("utils.lualine")

return {
    "nvim-lualine/lualine.nvim",
    opts = {
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
            lualine_a = {
                {
                    lualine.vim_mode,
                    color = function()
                        return { fg = lualine.mode_color[vim.fn.mode()], bg = colors.bg }
                    end,
                    padding = { left = 1, right = 0 },
                },
            },
            lualine_b = {
                {
                    "b:gitsigns_head",
                    icon = " " .. icons.git,
                    cond = lualine.conditions.check_git_workspace,
                    color = { fg = colors.blue, bg = colors.bg },
                    padding = 0,
                },
            },
            lualine_c = {
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
                    symbols = {
                        added = lazy_icons.git.added,
                        modified = lazy_icons.git.modified,
                        removed = lazy_icons.git.removed,
                    },
                    diff_color = {
                        added = { fg = colors.git.add, bg = colors.bg },
                        modified = { fg = colors.git.change, bg = colors.bg },
                        removed = { fg = colors.git.delete, bg = colors.bg },
                    },
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
                },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = colors.orange, bg = colors.bg },
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
            },
            lualine_y = {
                {
                    function()
                        return icons.debug .. require("dap").status()
                    end,
                    cond = function()
                        return package.loaded["dap"] and require("dap").status() ~= ""
                    end,
                    color = { fg = colors.red, bg = colors.bg },
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
            },
            lualine_z = {
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
        },
        extensions = { "neo-tree", "lazy" },
    },
}
