return {
    "ThePrimeagen/refactoring.nvim",
    keys = function()
        return {
            {
                "fXr",
                "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>",
                mode = "v",
                desc = "Refactor",
            },
            {
                "fXP",
                "<cmd>lua require('refactoring').debug.print_var({below = false})<cr>",
                desc = "Debug Print",
            },
            {
                "fXp",
                "<cmd>lua require('refactoring').debug.print_var({normal = true})<cr>",
                desc = "Debug Print Variable",
            },
            {
                "fXC",
                "<cmd>lua require('refactoring').debug.cleanup({})<cr>",
                desc = "Debug Cleanup",
            },
            {
                "fXp",
                "<cmd>lua require('refactoring').debug.print_var()<cr>",
                mode = "v",
                desc = "Debug Print Variable",
            },
            {
                "fXf",
                "<cmd>lua require('refactoring').refactor('Extract Function')<cr>",
                desc = "Extract function",
                mode = { "v" },
            },
            {
                "fXF",
                "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
                desc = "Extract function to file",
                mode = { "v" },
            },
            {
                "fXv",
                "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
                desc = "Extract variable",
                mode = { "v" },
            },
            {
                "fXi",
                "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
                desc = "Inline variable",
                mode = { "n", "v" },
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
        }
    end,
}
