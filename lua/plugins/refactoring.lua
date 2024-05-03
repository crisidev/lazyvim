return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup({})
    end,
    keys = {
        {
            "fXf",
            "<cmd>lua require('refactoring').refactor('Extract Function')<cr>",
            desc = "Extract function",
            mode = { "x" },
        },
        {
            "fXF",
            "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
            desc = "Extract function to file",
            mode = { "x" },
        },
        {
            "fXv",
            "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
            desc = "Extract variable",
            mode = { "x" },
        },
        {
            "fXi",
            "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
            desc = "Inline variable",
            mode = { "n", "x" },
        },
        {
            "fXI",
            "<cmd>lua require('refactoring').refactor('Inline Function')<cr>",
            desc = "Inline function",
            mode = { "n" },
        },
        {
            "fXb",
            "<cmd>lua require('refactoring').refactor('Extract Block')<cr>",
            desc = "Extract block",
            mode = { "n" },
        },
        {
            "fXB",
            "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>",
            desc = "Extract block to file",
            mode = { "n" },
        },
    },
}
