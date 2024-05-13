return {
    {
        "nvim-telescope/telescope.nvim",
        opts = function(_, opts)
            local actions = require("telescope.actions")
            local lga_actions = require("telescope-live-grep-args.actions")
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
                        ["<c-x>"] = require("telescope.actions.layout").toggle_preview,
                        ["<c-k>"] = lga_actions.quote_prompt(),
                        ["<c-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    },
                },
            })
        end,
        keys = function()
            local icons = require("config.theme").icons
            return {
                -- Main group
                {
                    "<leader>T",
                    "<cmd>lua require('utils.telescope').resume()<cr>",
                    desc = icons.clock .. "Last search",
                },
                {
                    "<leader>i",
                    "<cmd>lua require('utils.telescope').find_identifier()<cr>",
                    desc = icons.find .. "Find identifier",
                },
                {
                    "<leader>i",
                    "<cmd>lua require('utils.telescope').visual_selection()<cr>",
                    desc = icons.find .. "Find visual selection",
                    mode = { "x" },
                },
                {
                    "<leader>e",
                    "<cmd>lua require('utils.telescope').file_browser()<cr>",
                    desc = icons.folder .. "File browser",
                },
                {
                    "<leader>f",
                    "<cmd>lua require('utils.telescope').find_project_files()<cr>",
                    desc = icons.files .. "Find project files",
                },
                {
                    "<leader>F",
                    "<cmd>lua require('utils.telescope').find_files()<cr>",
                    desc = icons.files .. "Find all files",
                },

                {
                    "<leader>s",
                    "<cmd>lua require('utils.telescope').find_string()<cr>",
                    desc = icons.find .. "Find string",
                    mode = { "n" },
                },
                {
                    "<leader>s",
                    "<cmd>lua require('utils.telescope').find_string_visual()<cr>",
                    desc = icons.find .. "Find string",
                    mode = { "x" },
                },
                {
                    "<leader>r",
                    "<cmd>lua require('utils.telescope').smart_open()<cr>",
                    desc = icons.calendar .. "Smart open",
                },
                {
                    "<leader>z",
                    "<cmd>lua require('utils.telescope').zoxide()<cr>",
                    desc = icons.calendar .. "Zoxide",
                },
                {
                    "<leader>b",
                    "<cmd>lua require('utils.telescope').buffers()<cr>",
                    desc = icons.buffers .. "Buffers",
                },

                {
                    "<leader>Q",
                    "<cmd>lua require('utils.telescope').smart_quit()<cr>",
                    desc = icons.no .. "Quit",
                },
                {
                    "<leader>C",
                    "<cmd>lua require('utils.telescope').todo_comments()<cr>",
                    desc = icons.todo .. "Todos",
                },
                {
                    "<leader><space>",
                    "<cmd>Telescope commander<cr>",
                    desc = icons.commander .. "Commander",
                },
            }
        end,
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        module = "telescope._extensions.file_browser",
        lazy = true,
    },
    {
        "danielfalk/smart-open.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        module = "telescope._extensions.smart_open",
        lazy = true,
    },
    {
        "jvgrootveld/telescope-zoxide",
        module = "telescope._extensions.zoxide",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        module = "telescope._extensions.file_browser",
        lazy = true,
    },
    {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",
        lazy = true,
    },
    {
        "FeiyouG/commander.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("commander").setup({
                components = {
                    "DESC",
                    "CAT",
                    "KEYS",
                    "CMD",
                },
                sort_by = {
                    "DESC",
                    "CAT",
                },
                integration = {
                    telescope = {
                        enable = true,
                        theme = require("config.theme").telescope,
                    },
                    lazy = {
                        enable = true,
                        set_plugin_name_as_cat = true,
                    },
                },
            })
        end,
    },
}
