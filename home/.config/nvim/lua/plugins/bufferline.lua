return {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
        local theme = require("config.theme")
        local bufferline = require("utils.bufferline")
        opts.options.separator_style = "slant"
        opts.options.sort_by = "insert_after_current"
        opts.options.diagnostics_indicator = bufferline.diagnostic_indicator
        opts.options.groups = {
            options = {
                toggle_hidden_on_enter = true,
            },
            items = {
                require("bufferline.groups").builtin.pinned:with({ icon = "⭐" }),
                require("bufferline.groups").builtin.ungrouped,
                bufferline.language_group("rs", "rs", theme.colors.red),
                bufferline.language_group("py", "py", theme.colors.green),
                bufferline.language_group("kt", "kt", theme.colors.magenta),
                bufferline.language_group("js", "java", theme.colors.white),
                bufferline.language_group("lua", "lua", theme.colors.yellow),
                bufferline.language_group("rb", "rb", theme.colors.red1),
                bufferline.language_group("go", "go", theme.colors.blue),
                {
                    highlight = { sp = theme.colors.purple },
                    name = "tests",
                    icon = theme.icons.test,
                    matcher = bufferline.test_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.blue5 },
                    name = "docs",
                    icon = theme.icons.docs,
                    matcher = bufferline.doc_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.bg_br },
                    name = "cfg",
                    theme.icons.config,
                    matcher = bufferline.config_file_matcher,
                },
                {
                    highlight = { sp = theme.colors.bg },
                    name = "terms",
                    auto_close = true,
                    matcher = function(buf)
                        return buf.path:match("term://") ~= nil
                    end,
                },
            },
        }
        return opts
    end,
    keys = function()
        return {
            { "<F1>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer", mode = { "n", "i" } },
            { "<F2>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer", mode = { "n", "i" } },
            {
                "<A-S-Left>",
                "<cmd>BufferLineMovePrev<cr>",
                desc = "Move buffer left",
                mode = { "n", "i" },
            },
            {
                "<A-S-Right>",
                "<cmd>BufferLineMoveNext<cr>",
                desc = "Move buffer right",
                mode = { "n", "i" },
            },
            -- {
            --     "<leader>q",
            --     require("utils.bufferline").delete_buffer,
            --     desc = require("config.theme").icons.no .. "Close buffer",
            -- },
            {
                "<leader>Q",
                require("utils.bufferline").smart_quit,
                desc = require("config.theme").icons.no .. "Quit",
            },
        }
    end,
}
