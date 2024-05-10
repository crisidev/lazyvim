return {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
        require("config.theme").dap()
    end,
}
