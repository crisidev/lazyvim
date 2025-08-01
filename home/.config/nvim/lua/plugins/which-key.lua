local icons = require("config.theme").icons

return {
    "folke/which-key.nvim",
    opts = {
        preset = "modern",
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
                { "gD", "", hidden = true },
                { "gI", "", hidden = true },
                { "gy", "", hidden = true },
                { "gh", "", hidden = true },
                { "gH", "", hidden = true },
                { "g[", "", hidden = true },
                { "g]", "", hidden = true },
                { "g]", "", hidden = true },
                { "grn", "", hidden = true },
                { "gri", "", hidden = true },
                { "gra", "", hidden = true },
                { "grr", "", hidden = true },
            },
        },
    },
}
