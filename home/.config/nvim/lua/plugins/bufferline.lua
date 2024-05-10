return {
    "akinsho/bufferline.nvim",
    opts = function()
        local icons = require("config.theme").icons
        local bufferline = require("utils.bufferline")
        return {
            options = {
                separator_style = "slant",
                indicator = { style = "none" },
                max_name_length = 20,
                max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
                truncate_names = true, -- whether or not tab names should be truncated
                tab_size = 25,
                color_icons = true,
                diagnostics_update_in_insert = true,
                show_close_icon = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_tab_indicators = true,
                navigation = { mode = "uncentered" },
                mode = "buffers",
                sort_by = "insert_after_current",
                always_show_bufferline = false,
                hover = { enabled = true, reveal = { "close" } },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = bufferline.diagnostic_indicator,
                groups = {
                    options = {
                        toggle_hidden_on_enter = true,
                    },
                    items = {
                        require("bufferline.groups").builtin.pinned:with({ icon = "⭐" }),
                        require("bufferline.groups").builtin.ungrouped,
                        bufferline.language_group("rs", "rs", "#b7410e"),
                        bufferline.language_group("py", "py", "#195905"),
                        bufferline.language_group("kt", "kt", "#75368f"),
                        bufferline.language_group("js", "java", "#7db700"),
                        bufferline.language_group("lua", "lua", "#ffb300"),
                        bufferline.language_group("rb", "rb", "#ff4500"),
                        bufferline.language_group("go", "go", "#214b77"),
                        {
                            highlight = { sp = "#483d8b" },
                            name = "tests",
                            icon = icons.test,
                            matcher = bufferline.test_file_matcher,
                        },
                        {
                            highlight = { sp = "#009bff" },
                            name = "docs",
                            icon = icons.docs,
                            matcher = bufferline.doc_file_matcher,
                        },
                        {
                            highlight = { sp = "#636363" },
                            name = "cfg",
                            icons.config,
                            matcher = bufferline.config_file_matcher,
                        },
                        {
                            highlight = { sp = "#000000" },
                            name = "terms",
                            auto_close = true,
                            matcher = function(buf)
                                return buf.path:match("term://") ~= nil
                            end,
                        },
                    },
                },
                -- offsets = {
                --     {
                --         text = "EXPLORER",
                --         filetype = "neo-tree",
                --         highlight = "PanelHeading",
                --         text_align = "left",
                --         separator = true,
                --     },
                --     {
                --         text = "UNDOTREE",
                --         filetype = "undotree",
                --         highlight = "PanelHeading",
                --         separator = true,
                --     },
                --     {
                --         text = " LAZY",
                --         filetype = "lazy",
                --         highlight = "PanelHeading",
                --         separator = true,
                --     },
                --     {
                --         text = " DIFF VIEW",
                --         filetype = "DiffviewFiles",
                --         highlight = "PanelHeading",
                --         separator = true,
                --     },
                -- },
            },
        }
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
            {
                "<leader>q",
                require("utils.bufferline").delete_buffer,
                desc = require("config.theme").icons.no .. "Close buffer",
            },
            {
                "<leader>Q",
                require("utils.bufferline").smart_quit,
                desc = require("config.theme").icons.no .. "Quit",
            },
        }
    end,
}
