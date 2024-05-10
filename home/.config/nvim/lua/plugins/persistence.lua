return {
    "folke/persistence.nvim",
    keys = function()
        return {
            {
                "<leader>Sr",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>Sl",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>Sd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        }
    end,
}
