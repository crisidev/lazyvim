local icons = require("config.theme").icons

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
        -- triggers = {
        --     "<leader>",
        --     "<space>",
        --     "f",
        --     "z",
        --     "]",
        --     "[",
        -- },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "", -- symbol prepended to a group
        },
        spec = {
            {
                { "<leader>b", desc = "Buffers", icon = icons.buffers },
                { "<leader>s", desc = "Find String", icon = icons.find },
                { "<leader>w", desc = "Save Buffer", icon = icons.ok },
                { "<leader>f", desc = "Find Project Files", icon = icons.files },
                { "<leader>q", desc = "Close Buffer", icon = icons.no },
                { "<leader>S", desc = "Sessions", icon = icons.session },
                { "<leader>n", desc = "Noice", icon = icons.package },
                { "<leader>R", desc = "Rename", icon = icons.rename },
                { "<leader>x", desc = "Trouble", icon = icons.pinned },
                { "<leader>u", desc = "Ui", icon = icons.ui },
                { "gG", desc = "Chat GPT", icon = icons.gpt },
                { "gC", desc = "Codeium", icon = icons.copilot },
                { "gX", desc = "Refactoring", icon = icons.palette },
                { "gx", desc = "Follow link", icon = icons.link },
            },
        },
    },
}
