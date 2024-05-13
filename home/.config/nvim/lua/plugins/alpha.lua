return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        local alpha = require("utils.alpha")
        local theme = require("config.theme")
        local banner = {
            [[                                                                   ]],
            [[      ████ ██████           █████      ██                    ]],
            [[     ███████████             █████                            ]],
            [[     █████████ ███████████████████ ███   ███████████  ]],
            [[    █████████  ███    █████████████ █████ ██████████████  ]],
            [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
            [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
            [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
        }

        local header = {
            type = "group",
            val = alpha.colorize_header(banner),
        }

        local border_upper =
            alpha.text("╭───────────────────────────╮")
        local date = alpha.text("│  " .. theme.icons.calendar .. "Today is " .. os.date("%a %d %b") .. "    │")
        local nvim_version = alpha.text(
            "│  "
                .. theme.icons.vim
                .. "Neovim version "
                .. vim.version().major
                .. "."
                .. vim.version().minor
                .. "."
                .. vim.version().patch
                .. "  │"
        )
        local stats = require("lazy").stats()
        local plugin_count = alpha.text(
            "│  " .. theme.icons.package .. "Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins  │"
        )
        local border_lower =
            alpha.text("╰───────────────────────────╯")

        local footer = {
            type = "text",
            val = require("alpha.fortune")(),
            opts = {
                position = "center",
                hl = "Comment",
                hl_shortcut = "Comment",
            },
        }

        local buttons = {
            type = "group",
            name = "some",
            val = {
                {
                    type = "text",
                    val = "Quick links",
                    opts = {
                        hl = "String",
                        shrink_margin = false,
                        position = "center",
                    },
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = {
                        alpha.button(
                            "r",
                            theme.icons.clock .. " Smart open",
                            "<cmd>lua require('utils.telescope').smart_open()<cr>"
                        ),
                        alpha.button(
                            "l",
                            theme.icons.magic .. " Last session",
                            "<cmd>lua require('persistence').load({ last = true })<cr>"
                        ),
                        alpha.button(
                            "z",
                            theme.icons.folder .. " Zoxide",
                            "<cmd>lua require('utils.telescope').zoxide()<cr>"
                        ),
                        alpha.button(
                            "f",
                            theme.icons.file .. " Find file",
                            "<cmd>lua require('utils.telescope').find_project_files()<cr>"
                        ),
                        alpha.button(
                            "s",
                            theme.icons.text .. " Find word",
                            "<cmd>lua require('utils.telescope').find_string()<cr>"
                        ),
                        alpha.button("n", theme.icons.stuka .. " New file", "<cmd>ene <BAR> startinsert <cr>"),
                        alpha.button(
                            "b",
                            theme.icons.files .. " File browser",
                            "<cmd>lua require('utils.telescope').file_browser()<cr>"
                        ),
                        alpha.button("q", theme.icons.exit .. " Quit", "<cmd>quit<cr>"),
                    },
                    opts = { shrink_margin = false },
                },
            },
        }

        local mru = {
            type = "group",
            val = {
                {
                    type = "text",
                    val = "Recent files",
                    opts = {
                        hl = "String",
                        shrink_margin = false,
                        position = "center",
                    },
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function()
                        return { alpha.recent_files(0, vim.fn.getcwd()) }
                    end,
                    opts = { shrink_margin = false },
                },
            },
        }
        local sessions = {
            type = "group",
            val = {
                {
                    type = "text",
                    val = "Recent sessions",
                    opts = {
                        hl = "String",
                        shrink_margin = false,
                        position = "center",
                    },
                },
                { type = "padding", val = 1 },
                {
                    type = "group",
                    val = function()
                        return { alpha.recent_sessions(10, vim.fn.getcwd()) }
                    end,
                    opts = { shrink_margin = false },
                },
            },
        }

        theme.alpha_banner()
        require("alpha").setup({
            layout = {
                { type = "padding", val = 1 },
                header,
                { type = "padding", val = 1 },
                border_upper,
                date,
                nvim_version,
                plugin_count,
                border_lower,
                { type = "padding", val = 1 },
                buttons,
                { type = "padding", val = 1 },
                mru,
                { type = "padding", val = 1 },
                sessions,
                { type = "padding", val = 1 },
                footer,
            },
            opts = {
                margin = 0,
            },
        })
    end,
    keys = {
        { "<leader>;", "<cmd>Alpha<cr>", desc = require("config.theme").icons.dashboard .. "Dashboard" },
    },
}
