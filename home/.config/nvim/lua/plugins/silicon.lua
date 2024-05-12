return {
    "segeljakt/vim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        vim.cmd([[
            let g:silicon = {
              \   'theme': 'tokyonight_storm',
              \   'font': 'MonoLisa Nerd Font',
              \   'background':         '#202228',
              \   'shadow-color':       '#000000',
              \   'line-pad': 0,
              \   'pad-horiz': 20,
              \   'pad-vert': 20,
              \   'shadow-blur-radius': 0,
              \   'shadow-offset-x': 0,
              \   'shadow-offset-y': 0,
              \   'line-number': v:true,
              \   'round-corner': v:true,
              \   'window-controls': v:true,
              \   'output': "~/Pictures/vim-screenshots/silicon-{time:%Y-%m-%d-%H%M%S}.png",
              \ }
        ]])
    end,
}
