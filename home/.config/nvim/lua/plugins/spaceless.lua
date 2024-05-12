return {
    "lewis6991/spaceless.nvim",
    event = { "BufReadPost", "BufNew" },
    lazy = true,
    config = function()
        require("spaceless").setup()
    end,
}
