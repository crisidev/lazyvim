local icons = require("config.theme").icons
local spinners = require("noice.util.spinners")
spinners.spinners["moon"] = {
    -- stylua: ignore
    frames = {
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
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
            inc_rename = false,
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
        -- messages = {
        --     view_search = false,
        -- },
        routes = {
            {
                filter = {
                    event = "lsp",
                    kind = "progress",
                    cond = function(message)
                        local client = vim.tbl_get(message.opts, "progress", "client")
                        local title = vim.tbl_get(message.opts, "progress", "title")
                        return title == "Finding references" or client == "null-ls" or client == "grammar_guard"
                    end,
                },
                opts = { skip = true },
            },
            {
                filter = { find = "method textDocument/codeLens is not supported" },
                opts = { skip = true },
            },
            {
                filter = { find = "Invalid offset" },
                opts = { skip = true },
            },
            {
                filter = { kind = "echo", find = "[WakaTime]" },
                opts = { skip = true },
            },
        },
    },
    keys = function()
        return {
            {
                "<S-Enter>",
                "<cmd>lua require('noice').redirect(vim.fn.getcmdline())<cr>",
                mode = "c",
                desc = "Redirect Cmdline",
            },
            {
                "<leader>nl",
                "<cmd>lua require('noice').cmd('last')<cr>",
                desc = "Noice Last Message",
            },
            {
                "<leader>nh",
                "<cmd>lua require('noice').cmd('history')<cr>",
                desc = "Noice History",
            },
            {
                "<leader>na",
                "<cmd>lua require('noice').cmd('all')<cr>",
                desc = "Noice All",
            },
            {
                "<leader>nd",
                "<cmd>lua require('noice').cmd('dismiss')<cr>",
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
