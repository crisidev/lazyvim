return {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Coverage" },
    lazy = true,
    config = function()
        require("coverage").setup()
    end,
}
