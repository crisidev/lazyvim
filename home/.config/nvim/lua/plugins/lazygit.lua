local theme = require("config.theme")

return {
    "mikavilpas/tsugit.nvim",
    keys = {
        {
            "<c-g>",
            function()
                require("tsugit").toggle()
            end,
            desc = "Toggle lazygit",
        },
        {
            "<leader>gg",
            function()
                local absolutePath = vim.api.nvim_buf_get_name(0)
                require("tsugit").toggle_for_file(absolutePath)
            end,
            desc = "Lazygit file commits",
        },
    },
    opts = {
        keys = {
            toggle = "<c-g>",
            force_quit = "<c-c>",
        },
    },
}
