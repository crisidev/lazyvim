local theme = require("config.theme")

return {
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            defaults = {
                keymaps = false,
            },
            icons = {
                kinds = {
                    Snippet = " ", -- Emoji for snippets
                },
            },
        },
    },
    { "folke/flash.nvim", enabled = false },
    { "stevearc/conform.nvim", enabled = false },
    { "echasnovski/mini.surround", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "garymjr/nvim-snippets", enabled = false },
    { "lewis6991/gitsigns.nvim", enabled = true },
    { "sindrets/diffview.nvim", enabled = true },
}
