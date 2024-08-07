return {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
    },
    build = function()
        vim.cmd.GoInstallDeps()
    end,
}
