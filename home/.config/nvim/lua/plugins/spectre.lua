return {
    "nvim-pack/nvim-spectre",
    keys = function()
        return {
            {
                "<leader>Rf",
                "<cmd>lua require('spectre').open_file_search()<cr>",
                desc = "Current buffer",
            },
            {
                "<leader>Rp",
                "<cmd>lua require('spectre').open()<cr>",
                desc = "Whole project",
            },
            {
                "<leader>Rv",
                "<cmd>lua require('spectre').open_visual({ select_word = true })<cr>",
                desc = "Selected word",
            },
        }
    end,
}
