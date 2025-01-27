return {
    "andythigpen/nvim-coverage",
    version = "*",
    cmd = {
        "Coverage",
        "CoverageClear",
        "CoverageHide",
        "CoverageLoad",
        "CoverageLoadLcov",
        "CoverageShow",
        "CoverageSummary",
        "CoverageToggle",
    },
    lazy = true,
    config = function()
        local home = vim.env.HOME
        local llvm_path = home .. "/.nix-profile/bin"
        require("coverage").setup({
            auto_reload = true,
            lang = {
                rust = {
                    coverage_command = "grcov ${cwd} -s ${cwd} --llvm-path "
                        .. llvm_path
                        .. " --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
                },
            },
        })
    end,
    keys = {
        { "<leader>tcc", "<cmd>:Coverage<cr>", desc = "Generate coverage" },
        { "<leader>tcC", "<cmd>:CoverageClear<cr>", desc = "Clear coverage" },
        { "<leader>tct", "<cmd>:CoverageToggle<cr>", desc = "Toggle coverage" },
        { "<leader>tcl", "<cmd>:CoverageLoad<cr>", desc = "Load coverage" },
        { "<leader>tcL", "<cmd>:CoverageLoadLcov<cr>", desc = "Load lcov coverage" },
        { "<leader>tcs", "<cmd>:CoverageSummary<cr>", desc = "Show coverage summary" },
    },
}
