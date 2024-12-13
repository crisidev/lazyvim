return {
    "segeljakt/vim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        local home = vim.env.HOME
        vim.g.silicon = {
            theme = home .. "/.config/bat/themes/tokyonight.nvim/extras/sublime/tokyonight_storm.tmTheme",
            background = "#202228",
            font = "MonoLisa Nerd Font",
            ["line-number"] = true,
            ["line-pad"] = 0,
            output = home .. "/Pictures/Screenshots/neovim-{time:%Y-%m-%d-%H%M%S}.png",
            ["pad-horiz"] = 20,
            ["pad-vert"] = 20,
            ["round-corner"] = true,
            ["shadow-blur-radius"] = 0,
            ["shadow-color"] = "#000000",
            ["shadow-offset-x"] = 0,
            ["shadow-offset-y"] = 0,
            ["window-controls"] = true,
        }
    end,
}
