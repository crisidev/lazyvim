return {
    "folke/persistence.nvim",
    keys = function()
        return {
            {
                "<leader>Sr",
                "<cmd>lua require('persistence').load()<cr>",
                desc = "Restore Session",
            },
            {
                "<leader>Sl",
                "<cmd>lua require('persistence').load({ last = true })<cr>",
                desc = "Restore Last Session",
            },
            {
                "<leader>Sd",
                "<cmd>lua require('persistence').stop()<cr>",
                desc = "Don't Save Current Session",
            },
        }
    end,
}
