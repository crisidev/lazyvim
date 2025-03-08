return {
    {
        "LazyVim/LazyVim",
        opts = {
            defaults = {
                keymaps = false,
            },
        },
    },
    {
        "vhyrro/luarocks.nvim",
        enabled = false,
        priority = 1000,
        opts = {
            rocks = { "openssl" },
        },
    },
    { "folke/flash.nvim", enabled = false },
    { "stevearc/conform.nvim", enabled = false },
    { "mfussenegger/nvim-lint", enabled = false },
}
