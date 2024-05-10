return {
    "nvim-pack/nvim-spectre",
    keys = function()
        return {
            {
                "<leader>Rf",
                function()
                    require("spectre").open_file_search()
                end,
                desc = "Current buffer",
            },
            {
                "<leader>Rp",
                function()
                    require("spectre").open()
                end,
                desc = "Whole project",
            },
            {
                "<leader>Rv",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "Selected word",
            },
        }
    end,
}
