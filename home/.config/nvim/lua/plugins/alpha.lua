return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("alpha").setup(require("utils.alpha").dashboard())
    end,
    keys = {
        { "<leader>;", "<cmd>Alpha<cr>", desc = require("config.theme").icons.dashboard .. "Dashboard" },
    },
}
