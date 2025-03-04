local icons = require("config.theme").icons

return {
    "folke/which-key.nvim",
    opts = {
        preset = "modern",
        plugins = {
            presets = {
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                operators = false, -- adds help for operators like d, y, ...
                windows = false, -- default bindings on <c-w>
                nav = false, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = false, -- bindings for prefixed with g
            },
        },
        spec = {
            {
                { "<leader>b", desc = "Buffers", icon = icons.buffers },
                { "<leader>c", desc = "Code" },
                { "<leader>d", desc = "Debug" },
                { "<leader>s", desc = "Find String", icon = icons.find },
                { "<leader>w", desc = "Save Buffer", icon = icons.ok },
                { "<leader>f", desc = "Find Project Files", icon = icons.files },
                { "<leader>q", desc = "Close Buffer", icon = icons.no },
                { "<leader>S", desc = "Sessions", icon = icons.session },
                { "<leader>n", desc = "Noice" },
                { "<leader>R", desc = "Rename", icon = icons.rename },
                { "<leader>x", desc = "Trouble", icon = icons.pinned },
                { "<leader>u", desc = "Ui" },
                { "<leader>g", desc = "Git" },
                { "<leader>t", desc = "Tests" },
                { "gX", desc = "Refactoring", icon = icons.palette },
                { "gx", desc = "Follow link", icon = icons.link },
                { "gs", desc = "Surround", icon = icons.circular },
            },
        },
    },
}
