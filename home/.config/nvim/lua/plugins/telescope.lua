return {
    {
        "nvim-telescope/telescope.nvim",
        opts = function(_, opts)
            local actions = require("telescope.actions")
            opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
                mappings = {
                    n = {
                        ["<esc>"] = actions.close,
                        ["<c-c>"] = actions.close,
                        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                        ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                        ["<c-n>"] = actions.cycle_history_next,
                        ["<c-p>"] = actions.cycle_history_prev,
                        ["<c-x>"] = require("telescope.actions.layout").toggle_preview,
                    },
                    i = {
                        ["<esc>"] = actions.close,
                        ["<c-c>"] = actions.close,
                        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                        ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                        ["<c-n>"] = actions.cycle_history_next,
                        ["<c-p>"] = actions.cycle_history_prev,
                        ["<C-x>"] = require("telescope.actions.layout").toggle_preview,
                    },
                },
            })
        end,
        keys = function()
            local telescope = require("utils.telescope")
            local icons = require("config.theme").icons
            return {
                -- Main group
                { "<leader>T", telescope.resume, desc = icons.clock .. "Last search" },
                { "<leader>i", telescope.find_identifier, desc = icons.find .. "Find identifier" },
                { "<leader>E", telescope.file_browser, desc = icons.folder .. "File browser" },
                { "<leader>f", telescope.find_project_files, desc = icons.files .. "Find files" },
                { "<leader>s", telescope.find_string, desc = icons.find .. "Find string", mode = { "n" } },
                {
                    "<leader>s",
                    telescope.find_string_visual,
                    desc = icons.find .. "Find string",
                    mode = { "x" },
                },
                { "<leader>r", telescope.smart_open, desc = icons.calendar .. "Smart open" },
                { "<leader>z", telescope.zoxide, desc = icons.calendar .. "Zoxide" },
                { "<leader>b", telescope.buffers, desc = icons.buffers .. "Buffers" },

                -- <leader>F group
                { "<leader>Ff", telescope.find_files, desc = "Find files" },
                { "<leader>FF", telescope.only_certain_files, desc = "File certain filetype" },
                { "<leader>Fb", telescope.file_browser, desc = "File browser" },
                { "<leader>Fs", telescope.find_string, desc = "Find string", mode = { "n" } },
                { "<leader>Fs", telescope.find_string_visual, desc = "Find string", mode = { "x" } },
                { "<leader>FS", telescope.find_identifier, desc = "Find identifier under cursor" },
                { "<leader>Fz", telescope.zoxide, desc = "Zoxide list" },
                { "<leader>Fr", telescope.smart_open, desc = "Smart open" },
                { "<leader>Ft", telescope.todo_comments, desc = "Todos" },
            }
        end,
    },
    {
        "danielfalk/smart-open.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        module = "telescope._extensions.smart_open",
    },
    {
        "jvgrootveld/telescope-zoxide",
        module = "telescope._extensions.zoxide",
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        module = "telescope._extensions.file_browser",
    },
    {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",
    },
}
