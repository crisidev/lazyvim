return {
    "folke/which-key.nvim",
    opts = {
        plugins = {
            presets = {
                operators = false, -- adds help for operators like d, y, ...
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = false, -- default bindings on <c-w>
                nav = false, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = false, -- bindings for prefixed with g
            },
        },
        triggers = {
            "<leader>",
            "<space>",
            "f",
            "z",
            "]",
            "[",
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "", -- symbol prepended to a group
        },
    },
    config = function(_, opts)
        local icons = require("config.theme").icons

        local key_to_delete = {
            { { "n" }, "<leader>fp" },
        }

        for _, mapping in ipairs(key_to_delete) do
            local mode = mapping[1]
            local key = mapping[2]
            vim.keymap.del(mode, key)
        end

        local defaults = {
            mode = { "n", "v", "x" },
            ["<leader>F"] = { name = icons.telescope .. "Find" },
            ["<leader>d"] = { name = icons.debug .. "Debug" },
            ["<leader>t"] = { name = icons.test .. "Tests" },
            ["<leader>g"] = { name = icons.git .. "Git" },
            ["<leader>gh"] = { name = "Git" },
            ["<leader>x"] = { name = icons.pinned .. "Trouble" },
            ["<leader>n"] = { name = icons.package .. "Noice" },
            ["<leader>R"] = { name = icons.replace .. "Replace" },
            ["<leader>u"] = { name = icons.ui .. "Ui" },
            ["<leader>S"] = { name = icons.session .. "Session" },
            ["<leader>c"] = { name = icons.codelens .. "Code" },
            ["f"] = { name = icons.Function .. "Coding" },
            ["f?"] = { name = icons.debug .. "Debug" },
            ["fc"] = { name = icons.comment .. "Comment" },
            ["fB"] = { name = icons.nuclear .. "Build tools" },
            ["fG"] = { name = icons.gpt .. "Chat GPT" },
            ["fX"] = { name = icons.palette .. "Refactoring" },
            ["fC"] = { name = icons.copilot .. "Codeium" },
            ["<space>"] = { name = icons.gitlab .. "Gitlab" },
            ["<space>m"] = { name = "Merge request" },
        }
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(defaults)
    end,
}
