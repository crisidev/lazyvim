return {
    "ThePrimeagen/refactoring.nvim",
    keys = function()
        return {
            {
                "gXr",
                "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>",
                mode = "v",
                desc = "Refactor",
            },
            {
                "gXP",
                "<cmd>lua require('refactoring').debug.print_var({below = false})<cr>",
                desc = "Debug Print",
            },
            {
                "gXp",
                "<cmd>lua require('refactoring').debug.print_var({normal = true})<cr>",
                desc = "Debug Print Variable",
            },
            {
                "gXC",
                "<cmd>lua require('refactoring').debug.cleanup({})<cr>",
                desc = "Debug Cleanup",
            },
            {
                "gXp",
                "<cmd>lua require('refactoring').debug.print_var()<cr>",
                mode = "v",
                desc = "Debug Print Variable",
            },
            {
                "gXf",
                "<cmd>lua require('refactoring').refactor('Extract Function')<cr>",
                desc = "Extract function",
                mode = { "v" },
            },
            {
                "gXF",
                "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
                desc = "Extract function to file",
                mode = { "v" },
            },
            {
                "gXv",
                "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
                desc = "Extract variable",
                mode = { "v" },
            },
            {
                "gXi",
                "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
                desc = "Inline variable",
                mode = { "n", "v" },
            },
            {
                "gXI",
                "<cmd>lua require('refactoring').refactor('Inline Function')<cr>",
                desc = "Inline function",
                mode = { "n" },
            },
            {
                "gXb",
                "<cmd>lua require('refactoring').refactor('Extract Block')<cr>",
                desc = "Extract block",
                mode = { "n" },
            },
            {
                "gXB",
                "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>",
                desc = "Extract block to file",
                mode = { "n" },
            },
        }
    end,
}
