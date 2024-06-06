return {
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            defaults = {
                keymaps = false,
            },
        },
    },
    { "folke/flash.nvim", enabled = false },
    { "stevearc/conform.nvim", enabled = false },
    { "echasnovski/mini.surround", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "garymjr/nvim-snippets", enabled = false },
}
