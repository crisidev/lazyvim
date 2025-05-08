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
    { "lambdalisue/vim-suda" },
    { "folke/flash.nvim", enabled = false },
    { "stevearc/conform.nvim", enabled = false },
    { "mfussenegger/nvim-lint", enabled = false },
    { "mason-org/mason.nvim", version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
