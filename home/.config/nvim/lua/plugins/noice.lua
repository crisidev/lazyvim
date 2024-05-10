local icons = require("config.theme").icons
local spinners = require("noice.util.spinners")
spinners.spinners["moon"] = {
    frames = {
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
    },
    interval = 80,
}

return {
    "folke/noice.nvim",
    opts = {
        format = {
            spinner = {
                name = "moon",
            },
        },
        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = true,
        },
        cmdline = {
            view = "cmdline",
            format = {
                cmdline = { pattern = "^:", icon = icons.cmdline, lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = icons.search_down, lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = icons.search_up, lang = "regex" },
                filter = { pattern = "^:%s*!", icon = icons.bash, lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = icons.lua, lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = icons.help },
                calculator = { pattern = "^=", icon = icons.calculator, lang = "vimnormal" },
                input = {},
            },
        },
        lsp = {
            progress = {
                format_done = {},
            },
        },
        messages = {
            view_search = false,
        },
    },
    keys = function()
        return {
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "Redirect Cmdline",
            },
            {
                "<leader>nl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            {
                "<leader>nh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            {
                "<leader>na",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            {
                "<leader>nd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Forward",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Backward",
                mode = { "i", "n", "s" },
            },
        }
    end,
}
